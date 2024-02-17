//
//  InAppPurchase.swift
//
//
//  Created by Lkoberidze on 17.02.24.
//

import Foundation
import StoreKit

@MainActor
final public class InAppPurchase: NSObject, ObservableObject {

    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()

    private var updates: Task<Void, Never>? = nil
    private var productsLoaded = false
    private var subscriptionProducts: [SubscriptionProduct] = []

    var hasPurchased: Bool {
        !self.purchasedProductIDs.isEmpty
    }

    override public init() {
        super.init()
        self.updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        updates?.cancel()
    }
    
    func setSubscriptionProducts(_ products: [SubscriptionProduct]) {
        self.subscriptionProducts = products
    }

    public func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: subscriptionProducts.map({ $0.productId }))
        self.productsLoaded = true
    }

    public func purchase(_ productId: String) async throws -> PurchaseResult {
        let product = products.first(where: { $0.id == productId })
        let result = try await product?.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
            return .success(.verified)
        case let .success(.unverified(_, error)):
            print(error)
            return .success(.unverified(error))
        case .pending:
            return .pending
        case .userCancelled:
            return .userCancelled
        case .none:
            return .unknownError
        @unknown default:
            return .unknownError
        }
    }

    public func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    public func restore() async -> Bool {
        ((try? await AppStore.sync()) != nil)
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                // Using verificationResult directly would be better
                await self.updatePurchasedProducts()
            }
        }
    }
}

extension InAppPurchase: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) { }
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool { true }
}
