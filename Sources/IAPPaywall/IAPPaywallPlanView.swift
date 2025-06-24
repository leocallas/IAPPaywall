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
        ZStack(alignment: .topTrailing) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        if isSelected {
                            Image(.checkmarkCircle)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(plan.checkmarkIconColor)
                        } else {
                            Circle()
                                .foregroundStyle(.gray)
                                .frame(width: 18, height: 18)
                                .opacity(0.4)
                        }
                        
                        Text(
                            trial?.overridePlan?.planToOverride == plan.type && trial?.isEnabled == true
                            ? (resolvedText(trial?.overridePlan?.title ?? plan.title.title, id: plan.id))
                            : resolvedText(plan.title.title, id: plan.id)
                        )
                        .foregroundStyle(plan.title.color)
                        .font(plan.title.font)
                        
                        Spacer()
                    }
                    
                    if let subTitle = plan.subTitle {
                        Text(
                            trial?.overridePlan?.planToOverride == plan.type && trial?.isEnabled == true
                            ? (resolvedText(trial?.overridePlan?.subtitle ?? subTitle.title, id: plan.id))
                            : resolvedText(subTitle.title, id: plan.id)
                        )
                            .foregroundStyle(subTitle.color)
                            .font(subTitle.font)
                    }
                }
                
                if let rightTitle = plan.rightTitle {
                    Text(
                        trial?.overridePlan?.planToOverride == plan.type && trial?.isEnabled == true
                        ? (resolvedText(trial?.overridePlan?.rightTitle ?? rightTitle.title, id: plan.id))
                        : resolvedText(rightTitle.title, id: plan.id)
                    )
                        .foregroundStyle(rightTitle.color)
                        .font(rightTitle.font)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 80)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? plan.selectedBorderColor : plan.borderColor, lineWidth: 2)
            )
            .contentShape(Rectangle())
            
            if let promo = plan.promotion {
                Text(promo.title)
                    .foregroundStyle(promo.titleColor)
                    .font(promo.font)
                    .padding(.horizontal, 10)
                    .background(
                        Capsule()
                            .foregroundStyle(promo.backgroundColor ?? .clear)
                            .frame(height: 25)
                    )
                    .padding(.trailing, 24)
                    .offset(y: -8)
            }
        }
    }
    
    private func resolvedText(_ template: String, id: String) -> String {
        guard let product = purchaseManager.product(for: id) else {
            return template
                .replacingOccurrences(of: "{price}", with: "…")
                .replacingOccurrences(of: "{year_weekly_price}", with: "...")
                .replacingOccurrences(of: "{trial_duration}", with: "...")
        }
        return template
            .replacingOccurrences(of: "{price}", with: product.localizedPrice)
            .replacingOccurrences(of: "{year_weekly_price}", with: "\(product.formattedYearWeeklyPrice ?? "...")")
            .replacingOccurrences(of: "{trial_duration}", with: "\(purchaseManager.product(for: id)?.trialDuration ?? .zero)")
    }
}

#Preview {
    IAPPaywallPlanView(
        purchaseManager: .init(),
        plan: .init(
            id: "1",
            type: .monthly,
            title: .init(title: "title"),
            subTitle: .init(title: "subtitle"),
            rightTitle: .init(title: "${price} / mo"),
            promotion: .init(title: "promo 24% off")
        ),
        isSelected: false,
        trial: .init(
            isEnabled: true,
            onTitle: "title"
        )
    )
}
