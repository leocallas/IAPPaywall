//
//  IAPPaywallContentView.swift
//
//
//  Created by Lkoberidze on 15.02.24.
//

import SwiftUI

struct IAPPaywallContentView: View {

    @StateObject var purchaseManager: InAppPurchase

    @Binding var model: IAPPaywallModel
    @Binding var selectedPlan: IAPPaywallModel.Plan?
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 12,
            content: {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(model.bullets.titles, id: \.self) { title in
                            Text(title)
                                .font(model.bullets.font)
                                .foregroundStyle(model.bullets.color)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    ForEach(model.plans, id: \.productId) { plan in
                        IAPPaywallPlanView(
                            purchaseManager: purchaseManager,
                            plan: plan,
                            isSelected: selectedPlan == plan,
                            trial: model.trial
                        )
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.15)) {
                                selectedPlan = plan
                            }
                        }
                    }
                    
                    if let trial = model.trial {
                        HStack {
                            Toggle(isOn: Binding(
                                get: {
                                    if selectedPlan?.type != model.trial?.selectPlanOnToggle {
                                        return false
                                    }
                                    return trial.isEnabled
                                },
                                set: { isOn in
                                    model.trial?.isEnabled = isOn
                                    if let plan = trial.selectPlanOnToggle {
                                        selectedPlan = model.plans.first(where: { $0.type == plan })
                                    }
                                }
                            )) {
                                Text(
                                    model.trial?.isEnabled == true
                                    ? trial.onTitle : trial.offTitle ?? trial.onTitle
                                )
                                    .font(trial.titleFont)
                                    .foregroundStyle(trial.titleColor)
                            }
                            .tint(trial.toggleTintColor)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(trial.background)
                        .contentShape(Rectangle())
                        .padding(.vertical, 12)
                    }
                }
                .padding(.vertical)
            }
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .onAppear {
            selectedPlan = model.plans.first
        }
    }
}
