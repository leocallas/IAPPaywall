//
//  IAPPaywallHeaderView.swift
//
//
//  Created by Lkoberidze on 15.02.24.
//

import SwiftUI

struct IAPPaywallHeaderView<Content: View>: View {
    
    @ViewBuilder let content: Content

    var dismissAction: (() -> Void)
    
    var body: some View {
        content
            .overlay(
                Button(action: dismissAction) {
                    Image(systemName: "xmark")
                        .font(.callout)
                        .frame(width: 35, height: 35)
                        .foregroundStyle(Color.primary)
                        .background(.ultraThinMaterial, in: Circle())
                }
                    .padding(.top, 50)
                    .padding(.trailing, 15),
                alignment: .topTrailing
            )
    }
}
