//
//  IAPPaywallFooterView.swift
//
//
//  Created by Lkoberidze on 15.02.24.
//

import SwiftUI

struct IAPPaywallFooterView: View {
    
    @Binding var model: IAPPaywallModel

    var body: some View {
        VStack(spacing: .zero) {
            if let caption = model.payButton.caption {
                Text(caption.title)
                    .font(caption.font)
                    .foregroundStyle(caption.color)
            }
            
            Button(action: {
                
            }, label: {
                Text(model.payButton.title)
                    .foregroundStyle(model.payButton.titleColor)
            })
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .background(model.payButton.backgroundColor)
            .clipShape(Capsule())
            .padding(15)
            
            HStack {
                if let footerLinks = model.footerLinks {
                    ForEach(Array(footerLinks.enumerated()), id: \.element) { index, link in
                        Button(action: {
                            link.action()
                        }, label: {
                            Text(link.title)
                                .foregroundStyle(link.titleColor)
                                .font(link.titleFont)
                        })
                        
                        if index < (footerLinks.count - 1) {
                            Text(link.separatorSymbol)
                                .foregroundStyle(link.separatorSymbolColor)
                        }
                    }
                }
            }
        }
    }
}
