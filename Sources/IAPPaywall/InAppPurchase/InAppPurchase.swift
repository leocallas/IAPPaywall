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

    /// Fetched subscription products from the App Store
    @Published private(set) var products: [Product] = []

    /// Set of product identifiers the user has purchased and are currently valid
    @Published private(set) var purchasedProductIDs = Set<String>()

    private var updates: Task<Void, Never>? = nil
    private var productsLoaded = false

    // MARK: - Public Properties

    public static var shared: InAppPurchase = InAppPurchase()

    /// Returns true if the user has any active purchased product
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

    /// Loads product metadata for the provided subscription product definitions
    /// - Parameter subscriptionProducts: List of local product models with App Store product identifiers
    internal func setSubscriptionProducts(_ subscriptionProducts: [SubscriptionProduct]) {
        guard !self.productsLoaded else { return }
        Task {
            self.products = try await Product.products(for: subscriptionProducts.map({ $0.productId }))
            self.productsLoaded = true
        }
    }

    /// Observes transaction updates from the App Store and updates local purchase state
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                // Updates local entitlement state for current user
                // NOTE: Using verificationResult directly would be better
                await self.updatePurchasedProducts()
            }
        }
    }

    // MARK: - Public API
    
    public static func configure() {
        Task {
            await shared.updatePurchasedProducts()
        }
    }

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
            return .success(.verified, result)
        case let .success(.unverified(_, error)):
            return .success(.unverified(error), result)
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

    /// Updates the set of currently active purchased product identifiers by verifying entitlements
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
    
    /// Returns the `Product` from StoreKit for a given product identifier, if it exists
    public func product(for productId: String) -> Product? {
        return products.first(where: { $0.id == productId })
    }
}

// MARK: - SKPaymentTransactionObserver

extension InAppPurchase: @preconcurrency SKPaymentTransactionObserver {
    /// Required by StoreKit to handle legacy transactions, not used here
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) { }
    
    /// Allows promotional purchases from the App Store (outside the app) to auto-present the purchase UI
    public func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool { true }
}
