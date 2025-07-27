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
                HStack(spacing: 12) {
                    caption.icon?
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(caption.iconTint ?? .white)
                        
                    Text(
                        model.trial?.payButtonCaptionOverride != nil && model.trial?.isEnabled == true
                        ? model.trial?.payButtonCaptionOverride ?? caption.title
                        : caption.title
                    )
                    .font(caption.font)
                    .foregroundStyle(caption.color)
                }
            }
            
            model.payButton.makeWrappedButton {
                Task {
                    do {
                        let result = try await purchaseManager.purchase(selectedPlan?.id ?? "")
                        onPurchase?(result, selectedPlan)
                    } catch {
                        onPurchase?(.unknownError, nil)
                    }
                }
            }
            
            HStack {
                ForEach(Array(model.footerLinks.enumerated()), id: \.element) { index, link in
                    Button(action: {
                        link.action()
                    }, label: {
                        Text(link.title)
                            .foregroundStyle(link.titleColor)
                            .font(link.titleFont)
                    })
                    
                    if index < (model.footerLinks.count - 1) {
                        Text(link.separatorSymbol)
                            .foregroundStyle(link.separatorSymbolColor)
                    }
                }
            }
        }
        .onAppear(
            perform: {
                purchaseManager.setSubscriptionProducts(
                    model.plans.map(
                        {
                            SubscriptionProduct(
                                title: $0.title.title,
                                description: nil,
                                productId: $0.id
                            )
                        })
                )
            addRestoreButton()
        })
        .zIndex(100)
    }

    private func addRestoreButton() {
        model.footerLinks.insert(.init(
            title: "Restore",
            titleFont: model.footerLinks.first?.titleFont ?? .caption,
            titleColor: model.footerLinks.first?.titleColor ?? .black,
            separatorSymbol: model.footerLinks.first?.separatorSymbol ?? "•",
            separatorSymbolColor: model.footerLinks.first?.separatorSymbolColor ?? Color.gray.opacity(0.7),
            action: {
                Task {
                    let successfullyRestored = await purchaseManager.restore()
                    if successfullyRestored {
                        await purchaseManager.updatePurchasedProducts()
                    }
                    onRestore?(successfullyRestored)
                }
            }
        ), at: .zero)
    }
}
