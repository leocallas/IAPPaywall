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
                .stroke(plan.selectedBorderColor, lineWidth: 2)
                .opacity(isSelected ? 1 : 0.3)
        )
    }
}

#Preview {
    IAPPaywallPlanView(plan: .init(
        id: "", 
        iconColor: .black,
        title: .init(title: "Monthly", color: .black, font: .body.bold()),
        subTitle: .init(title: "Get full access for just $3.99/mo", color: .black, font: .body),
        promotion: .init(title: "74% OFF", titleColor: .white, font: .caption, backgroundColor: .black),
        selectedBorderColor: .black
    ), isSelected: false)
}
