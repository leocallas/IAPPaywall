//
//  IAPPaywallFooterView.swift
//
//
//  Created by Lkoberidze on 15.02.24.
//

import SwiftUI

struct IAPPaywallFooterView: View {
    
    @Binding var model: IAPPaywallModel
    @Binding var selectedPlan: IAPPaywallModel.Plan?
    @StateObject var purchaseManager: InAppPurchase
    @Binding var hasPurchased: Bool

    var onPurchase: ((PurchaseResult, IAPPaywallModel.Plan?) -> Void)?
    var onRestore: ((Bool) -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            if let caption = model.payButton.caption {
                caption(model.trial?.isEnabled == true)
            }
            
            Button(action: {
                Task {
                    do {
                        let result = try await purchaseManager.purchase(selectedPlan?.id ?? "")
                        onPurchase?(result, selectedPlan)
                    } catch {
                        onPurchase?(.unknownError, nil)
                    }
                }
            }, label: {
                model.payButton.content(model.trial?.isEnabled == true)
            })
            
            if let footer = model.footer {
                HStack {
                    footer.content
                    
                    Button(
                        action: {
                            Task {
                                let successfullyRestored = await purchaseManager.restore()
                                if successfullyRestored {
                                    await purchaseManager.updatePurchasedProducts()
                                }
                                onRestore?(successfullyRestored)
                            }
                        },
                        label: {
                            Text("Restore")
                                .foregroundStyle(footer.restoreButtonColor)
                                .font(footer.restoreButtonFont)
                        }
                    )
                }
            }
        }
        .onAppear {
            purchaseManager.setSubscriptionProducts(
                model.plans.map(
                    {
                        SubscriptionProduct(
                            title: $0.id,
                            description: nil,
                            productId: $0.id
                        )
                    }
                )
            )
        }
        .zIndex(100)
    }
}
