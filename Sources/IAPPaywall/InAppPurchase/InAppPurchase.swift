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

    // MARK: - Private Properties

    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()

    private var updates: Task<Void, Never>? = nil
    private var productsLoaded = false

    // MARK: - Public Properties

    public var hasPurchased: Bool {
        !self.purchasedProductIDs.isEmpty
    }

    // MARK: - Init

    override public init() {
        super.init()
        self.updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        updates?.cancel()
    }
    
    // MARK: - Internal & Private Methods

    internal func setSubscriptionProducts(_ subscriptionProducts: [SubscriptionProduct]) {
        guard !self.productsLoaded else { return }
        Task {
            self.products = try await Product.products(for: subscriptionProducts.map({ $0.productId }))
            self.productsLoaded = true
        }
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                // Using verificationResult directly would be better
                await self.updatePurchasedProducts()
            }
        }
    }

    // MARK: - Public Methods
    
    /// Initiates a purchase for the product with the App Store and displays the confirmation sheet.
    /// - Parameter productId: A unique alphanumeric ID that is assigned on each subscription / inapp product on the appstoreconnect
    /// - Returns: The result state of the purchase
    public func purchase(_ productId: String) async throws -> PurchaseResult {
        let product = products.first(where: { $0.id == productId })
        let result = try await product?.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
            return .success(.verified(transaction))
        case let .success(.unverified(transaction, error)):
            return .success(.unverified(transaction, error))
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
    
    /// Synchronizes your app’s transaction information and subscription status with information from the App Store.
    /// - Returns: True if found transaction information and restoration is successful
    public func restore() async -> Bool {
        ((try? await AppStore.sync()) != nil)
    }
}

// MARK: - SKPaymentTransactionObserver

extension InAppPurchase: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) { }
    public func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool { true }
}
