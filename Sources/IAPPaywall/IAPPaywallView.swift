// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

struct IAPPaywallView: View {

    @Binding var model: IAPPaywallModel
    @State var selectedPlan: IAPPaywallModel.Plan?
    @State var hasPurchased: Bool = false

    private(set) var onPurchase: ((PurchaseResult) -> Void)?
    private(set) var onRestore: ((Bool) -> Void)?

    var body: some View {
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

extension IAPPaywallView {
    func onPurchase(perform action: @escaping (PurchaseResult) -> Void) -> Self {
        var copy = self
        copy.onPurchase = action
        return copy
    }
    
    func onRestore(perform action: @escaping (Bool) -> Void) -> Self {
        var copy = self
        copy.onRestore = action
        return copy
    }
}
