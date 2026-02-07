//
//  IAPPaywallPlanView.swift
//
//
//  Created by Lkoberidze on 15.02.24.
//

import SwiftUI

struct IAPPaywallPlanView: View {
    
    @StateObject var purchaseManager: InAppPurchase

    var plan: IAPPaywallModel.Plan
    var isSelected: Bool
    var trial: IAPPaywallModel.Trial?

    var body: some View {
        let product = purchaseManager.cachedProduct(for: plan.id)
        let planData = IAPPaywallModel.Plan.PlanData(
            price: product?.localizedPrice ?? "...",
            yearWeeklyPrice: product?.formattedYearWeeklyPrice ?? "...",
            trialDuration: product?.trialDuration ?? .zero,
            isFreeTrialEnabled: trial?.isEnabled == true,
            isSelected: isSelected
        )
        ZStack(alignment: .topTrailing) {
            plan.content?(planData)
            if let promo = plan.promo {
                promo(planData)
                    .padding(.trailing, 24)
                    .offset(y: -8)
            }
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    IAPPaywallPlanView(
        purchaseManager: .init(),
        plan: .init(
            id: "1",
            type: .monthly,
            content: { _ in
                AnyView (
                    Text("Title")
                )
            },
            promo: { _ in
                AnyView (
                    Text("promo 24% off")
                )
            }
        ),
        isSelected: false,
        trial: .init(
            isEnabled: true,
            onTitle: "title"
        )
    )
}
