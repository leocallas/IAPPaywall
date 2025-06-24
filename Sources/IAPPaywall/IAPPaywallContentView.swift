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
                    
                    ForEach(model.plans) { plan in
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
                                    if selectedPlan?.type != model.trial?.overridePlan?.planToOverride {
                                        return false
                                    }
                                    return trial.isEnabled
                                },
                                set: { isOn in
                                    model.trial?.isEnabled = isOn
                                    if trial.shouldSelectOverridePlan {
                                        selectedPlan = model.plans.first(where: { $0.type == trial.overridePlan?.planToOverride })
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(trial.borderColor, lineWidth: 2)
                        )
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

#Preview {
    IAPPaywallContentView(
        purchaseManager: .init(),
        model: .init(
            get: {
                .init(
                    isStretchy: false,
                    isSticky: false,
                    payButton: .init(
                        title: "pay",
                        titleColor: .accentColor,
                        font: .body,
                        backgroundColor: .white
                    ),
                    footerLinks: [],
                    plans: [
                        .init(
                            id: "12",
                            type: .yearly,
                            title: .init(title: "title"),
                            subTitle: .init(title: "subtitle")
                        ),
                        .init(
                            id: "15",
                            type: .monthly,
                            title: .init(title: "title"),
                            subTitle: .init(title: "subtitle")
                        )
                    ],
                    bullets: ([
                        "123123123", "12312398", "12312398"
                    ], font: .body, color: .black),
                    trial: .init(
                        isEnabled: true,
                        onTitle: "on title"
                    )
                )
            },
            set: { _ in
                
            }
        ),
        selectedPlan: .init(
            get: {
                .init(
                    id: "12",
                    type: .yearly,
                    title: .init(title: "title"),
                    subTitle: .init(title: "subtitle")
                )
            },
            set: { _ in
                
            }
        )
    )
}
