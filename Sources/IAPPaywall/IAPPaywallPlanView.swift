//
//  IAPPaywallPlanView.swift
//
//
//  Created by Lkoberidze on 15.02.24.
//

import SwiftUI

struct IAPPaywallPlanView: View {
    
    var plan: IAPPaywallModel.Plan
    var isSelected: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    if isSelected {
                        Image("checkmarkCircle", bundle: .module)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(plan.iconColor)
                    } else {
                        Circle()
                            .foregroundStyle(.gray)
                            .frame(width: 18, height: 18)
                            .opacity(0.4)
                    }
                    
                    Text(plan.title.title)
                        .foregroundStyle(plan.title.color)
                        .font(plan.title.font)
                    
                    Spacer()
                    
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
                    }
                }
                
                Text(plan.subTitle.title)
                    .foregroundStyle(plan.subTitle.color)
                    .font(plan.subTitle.font)
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 80)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? plan.selectedBorderColor : plan.borderColor, lineWidth: 2)
        )
    }
}
