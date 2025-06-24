// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct IAPPaywallView<Header: View>: View {

    @Environment(\.dismiss) var dismiss

    @ViewBuilder let header: Header

    @State public var model: IAPPaywallModel
    @State var selectedPlan: IAPPaywallModel.Plan?
    @State var hasPurchased: Bool = false
    @StateObject var purchaseManager: InAppPurchase = .shared

    private(set) var onPurchase: ((PurchaseResult, IAPPaywallModel.Plan?) -> Void)?
    private(set) var onRestore: ((Bool) -> Void)?

    public init(
        header: Header,
        model: IAPPaywallModel
    ) {
        self.header = header
        self.model = model
    }

    public var body: some View {
        VStack(spacing: 16) {
            ScrollView {
                VStack(spacing: .zero) {
                    IAPPaywallHeaderView(
                        content: { header },
                        dismissAction: { dismiss() }
                    )
                    IAPPaywallContentView(
                        purchaseManager: purchaseManager,
                        model: $model,
                        selectedPlan: $selectedPlan
                    )
                }
            }
            .clipShape(.rect)
            .coordinateSpace(name: "scroll")
            .ignoresSafeArea(.container, edges: .top)
            .scrollIndicators(.hidden)
            
            IAPPaywallFooterView(
                model: $model,
                selectedPlan: $selectedPlan,
                purchaseManager: purchaseManager,
                hasPurchased: $hasPurchased,
                onPurchase: onPurchase,
                onRestore: onRestore
            )
        }
    }
}

extension IAPPaywallView {
    public func onPurchase(perform action: @escaping (PurchaseResult, IAPPaywallModel.Plan?) -> Void) -> Self {
        var copy = self
        copy.onPurchase = action
        return copy
    }
    
    public func onRestore(perform action: @escaping (Bool) -> Void) -> Self {
        var copy = self
        copy.onRestore = action
        return copy
    }
}
