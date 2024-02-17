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
    @StateObject var purchaseManager = InAppPurchase()
    @Binding var hasPurchased: Bool

    var onPurchase: ((PurchaseResult) -> Void)?
    var onRestore: ((Bool) -> Void)?

    var body: some View {
        VStack(spacing: .zero) {
            if let caption = model.payButton.caption {
                Text(caption.title)
                    .font(caption.font)
                    .foregroundStyle(caption.color)
            }
            
            Button(action: {
                Task {
                    do {
                        let purchaseResult = try await purchaseManager.purchase(selectedPlan?.id ?? "")
                        onPurchase?(purchaseResult)
                    } catch {
                        onPurchase?(.unknownError)
                    }
                }
            }, label: {
                Text(model.payButton.title)
                    .font(model.payButton.font)
                    .foregroundStyle(model.payButton.titleColor)
            })
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .background(model.payButton.backgroundColor)
            .clipShape(Capsule())
            .padding(15)
            
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
        .onAppear(perform: {
            purchaseManager.setSubscriptionProducts(model.plans.map({ SubscriptionProduct(title: $0.title.title, description: $0.subTitle.title, productId: $0.id) }))
            addRestoreButton()
        })
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
