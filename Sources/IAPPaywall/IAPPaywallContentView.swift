//
//  IAPPaywallContentView.swift
//
//
//  Created by Lkoberidze on 15.02.24.
//

import SwiftUI

struct IAPPaywallContentView: View {

    @Binding var model: IAPPaywallModel
    @Binding var selectedPlan: IAPPaywallModel.Plan?

    var body: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text(model.title.title)
                .font(model.title.font)
                .foregroundStyle(model.title.color)
            
            if let subTitle = model.subTitle {
                Text(subTitle.subTitle)
                    .font(subTitle.font)
                    .foregroundStyle(subTitle.color)
            }
            
            if let points = model.points {
                VStack(spacing: 15) {
                    ForEach(points) { point in
                        IAPPaywallPointView(point: point)
                    }
                }
                .padding(.top, 12)
            }
            
            VStack {
                ForEach(model.plans) { plan in
                    IAPPaywallPlanView(plan: plan, isSelected: selectedPlan == plan)
                        .onTapGesture {
                            selectedPlan = plan
                        }
                }
            }
            .padding(.vertical)
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .onAppear {
            selectedPlan = model.plans.first
        }
    }
}
