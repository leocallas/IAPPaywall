//
//  IAPPaywallHeaderView.swift
//
//
//  Created by Lkoberidze on 15.02.24.
//

import SwiftUI

struct IAPPaywallHeaderView: View {
    
    @Binding var model: IAPPaywallModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            let minY = geometry.frame(in: .global).minY
            let headerHeight = size.height - (60 + geometry.safeAreaInsets.top + 50)
            let progress = min(max((-minY / headerHeight), .zero), 1)
            let limitedMinY = -minY > headerHeight ? -(minY + headerHeight) : .zero
            
            if let headerImage = model.header.image {
                headerImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height + (model.header.isStretchy ? (minY > .zero ? minY : .zero) : .zero))
                    .overlay(content: {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .opacity(progress)
                            .overlay(alignment: .bottom) {
                                Text(model.header.title)
                                    .font(model.header.font)
                                    .foregroundStyle(model.header.color)
                                    .offset(y: 90 - (100 * progress))
                            }
                    })
                    .clipped()
                    .offset(y: model.header.isSticky ? (minY > .zero ? -minY : limitedMinY) : .zero)
                    .overlay(alignment: .topTrailing) {
                        Button(action: { dismiss() }, label: {
                            Image(systemName: "xmark")
                                .font(.callout)
                                .frame(width: 35, height: 35)
                                .foregroundStyle(Color.primary)
                                .background(.ultraThinMaterial, in: .circle)
                                .contentShape(.circle)
                        })
                        .padding(.top, geometry.safeAreaInsets.top + 50)
                        .padding(.trailing, 15)
                        .offset(y: -minY)
                    }
            }
        })
        .frame(height: 300)
        .zIndex(1000)
    }
}
