//
//  InAppPurchase.swift
//
//
//  Created by Lkoberidze on 17.02.24.
//

import Foundation
import StoreKit
import SwiftUI
import Combine

@MainActor
final public class InAppPurchase: NSObject, ObservableObject {

    // MARK: - Public Properties

    public static var shared: InAppPurchase = InAppPurchase()

    /// Testing flag to set in app purchases disabled
    public var inAppPurchasesEnabled: Bool = true

    /// Returns true if the user has any active purchased product
    public var hasPurchased: Bool {
        inAppPurchasesEnabled ? !self.purchasedProductIDs.isEmpty : true
    }

    // MARK: - Private Properties

    /// Fetched subscription products from the App Store
    @Published private(set) var products: [Product] = []

    /// Set of product identifiers the user has purchased and are currently valid
    @Published private(set) var purchasedProductIDs = Set<String>()

    @Published private var cachedProductDisplay: [CachedProduct] = []

    private var updates: Task<Void, Never>? = nil
    private var productsLoaded = false
    private let productCacheKey = "cachedProducts"
    private let purchasedIDsKey = "purchasedProductIDs"

    // MARK: - Init

    override public init() {
        super.init()
        self.loadCachedProducts()
        self.loadCachedPurchasedProductIDs()
        self.updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)

        Task {
            await tryFetchingStoreData()
        }
    }

    deinit {
        updates?.cancel()
    }
    
    // MARK: - Public API
    
    public static func configure() {
        Task {
            await shared.updatePurchasedProducts()
        }
    }

    /// Enable or disable testing mode to simulate purchases
    /// - Parameter value: When true, hasPurchased will always return true
    public func setDisabled(_ value: Bool = true) {
        inAppPurchasesEnabled = !value
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
            purchasedProductIDs.insert(transaction.productID)
            cachePurchasedProductIDs(purchasedProductIDs)
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
        var updatedSet = Set<String>()

        for await result in Transaction.currentEntitlements {
            if case let .verified(transaction) = result,
               transaction.revocationDate == nil {
                updatedSet.insert(transaction.productID)
            }
        }

        self.purchasedProductIDs = updatedSet
        self.cachePurchasedProductIDs(updatedSet)
    }
    
    /// Synchronizes your app’s transaction information and subscription status with information from the App Store.
    /// - Returns: True if found transaction information and restoration is successful
    public func restore() async -> Bool {
        ((try? await AppStore.sync()) != nil)
    }
    
    /// Returns the `Product` from StoreKit for a given product identifier, if it exists
    public func product(for productId: String) -> Product? {
        products.first(where: { $0.id == productId })
    }
    
    /// Returns the `CachedProduct` from for a given product identifier, if it exists
    public func cachedProduct(for productId: String) -> CachedProduct? {
        cachedProductDisplay.first(where: { $0.id == productId }) ?? products.first(where: { $0.id == productId }).map {
            CachedProduct(
                id: $0.id,
                localizedPrice: $0.localizedPrice,
                formattedYearWeeklyPrice: $0.formattedYearWeeklyPrice,
                trialDuration: $0.trialDuration
            )
        }
    }

    // MARK: - Internal & Private Methods

    /// Loads product metadata for the provided subscription product definitions
    /// - Parameter subscriptionProducts: List of local product models with App Store product identifiers
    internal func setSubscriptionProducts(_ subscriptionProducts: [SubscriptionProduct]) {
        guard !self.productsLoaded else { return }
        Task {
            do {
                let fetched = try await Product.products(for: subscriptionProducts.map(\.productId))
                self.products = fetched
                self.productsLoaded = true
                self.cacheProducts(fetched)
            } catch {
                // Failed to load from network, fallback already handled in init
            }
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
    
    private func tryFetchingStoreData() async {
        await updatePurchasedProducts()
        await reloadStoreProducts()
    }
    
    // MARK: - Product Caching
    
    private func cachePurchasedProductIDs(_ ids: Set<String>) {
        UserDefaults.standard.set(Array(ids), forKey: purchasedIDsKey)
    }

    private func loadCachedPurchasedProductIDs() {
        let ids = UserDefaults.standard.stringArray(forKey: purchasedIDsKey) ?? []
        purchasedProductIDs = Set(ids)
    }
    
    private func cacheProducts(_ products: [Product]) {
        let cached: [CachedProduct] = products.map {
            CachedProduct(
                id: $0.id,
                localizedPrice: $0.localizedPrice,
                formattedYearWeeklyPrice: $0.formattedYearWeeklyPrice,
                trialDuration: $0.trialDuration
            )
        }
        
        if let data = try? JSONEncoder().encode(cached) {
            UserDefaults.standard.set(data, forKey: productCacheKey)
        }
    }
    
    private func loadCachedProducts() {
        guard
            let data = UserDefaults.standard.data(forKey: productCacheKey),
            let cached = try? JSONDecoder().decode([CachedProduct].self, from: data) else {
            return
        }
        cachedProductDisplay = cached
    }
    
    // MARK: - Network Check

    private func reloadStoreProducts() async {
        guard productsLoaded else { return }
        do {
            let updated = try await Product.products(for: products.map(\.id))
            self.products = updated
            cacheProducts(updated)
        } catch {
        }
    }
}

// MARK: - SKPaymentTransactionObserver

extension InAppPurchase: @preconcurrency SKPaymentTransactionObserver {
    /// Required by StoreKit to handle legacy transactions, not used here
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) { }
    
    /// Allows promotional purchases from the App Store (outside the app) to auto-present the purchase UI
    public func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool { true }
}
