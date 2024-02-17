//
//  IAPPaywallModel.swift
//
//
//  Created by Lkoberidze on 15.02.24.
//

import SwiftUI

struct IAPPaywallModel {
    var title: Title
    var subTitle: SubTitle?
    var header: Header
    var points: [Point]?
    var payButton: PayButton
    var footerLinks: [FooterLink]?
    
    struct Title {
        var title: String
        var font: Font
        var color: Color
    }

    struct SubTitle {
        var subTitle: String
        var font: Font
        var color: Color
    }

    struct Header {
        var title: String
        var font: Font
        var color: Color
        var image: Image?
        var isSticky: Bool = true
        var isStretchy: Bool = true
    }

    struct PayButton {
        var title: String
        var titleColor: Color
        var backgroundColor: Color
        var caption: Caption?
        
        struct Caption {
            var title: String
            var font: Font
            var color: Color
        }
    }

    struct Point: Identifiable {
        var id: UUID = UUID()
        var icon: Image
        var title: String
        var font: Font
        var color: Color
    }

    struct FooterLink: Identifiable, Hashable {
        var id: UUID = UUID()
        var title: String
        var titleFont: Font = .caption
        var titleColor: Color
        var separatorSymbol: String = "•"
        var separatorSymbolColor: Color = Color.gray.opacity(0.7)
        var action: (() -> Void)
        
        func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
        
        static func == (lhs: IAPPayWallModel.FooterLink, rhs: IAPPayWallModel.FooterLink) -> Bool {
            lhs.id == rhs.id
        }
    }
}
