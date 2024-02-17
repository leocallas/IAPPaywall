//
//  IAPPaywallPointView.swift
//
//
//  Created by Lkoberidze on 15.02.24.
//

import SwiftUI

struct IAPPaywallPointView: View {
    
    var point: IAPPaywallModel.Point

    var body: some View {
        HStack(spacing: .zero) {
            ZStack {
                point.icon
                    .resizable()
                    .frame(width: 17, height: 17)
            }
            
            Text(point.title)
                .font(point.font)
                .foregroundStyle(point.color)
                .padding(.leading, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
