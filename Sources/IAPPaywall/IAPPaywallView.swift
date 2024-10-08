// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct IAPPaywallView: View {

    @State public var model: IAPPaywallModel
    @State var selectedPlan: IAPPaywallModel.Plan?
    @State var hasPurchased: Bool = false

    private(set) var onPurchase: ((PurchaseResult, IAPPaywallModel.Plan?) -> Void)?
    private(set) var onRestore: ((Bool) -> Void)?

    public init(model: IAPPaywallModel) {
        self.model = model
    }

    public var body: some View {
        VStack {
            ScrollView {
                VStack {
                    IAPPaywallHeaderView(model: $model)
                    IAPPaywallContentView(model: $model, selectedPlan: $selectedPlan)
                }
            }
            .ignoresSafeArea(.container, edges: .top)
            .scrollIndicators(.hidden)
            
            IAPPaywallFooterView(
                model: $model,
                selectedPlan: $selectedPlan,
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
