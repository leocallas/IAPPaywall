//
//  IAPPaywallModel.swift
//
//
//  Created by Lkoberidze on 15.02.24.
//

import SwiftUI

public struct IAPPaywallModel {
    var title: Title
    var subTitle: SubTitle?
    var header: Header
    var points: [Point]?
    var payButton: PayButton
    var footerLinks: [FooterLink] = []
    var plans: [Plan]
    
    struct Title {
        var title: String
        var font: Font = .largeTitle.bold()
        var color: Color = .black
    }

    struct SubTitle {
        var subTitle: String
        var font: Font = .body
        var color: Color = .black
    }

    struct Header {
        var title: String
        var font: Font = .body
        var color: Color = .black
        var image: Image?
        var isSticky: Bool = true
        var isStretchy: Bool = true
    }

    struct PayButton {
        var title: String
        var titleColor: Color = .white
        var font: Font = .body
        var backgroundColor: Color = .black
        var caption: Caption?
        
        struct Caption {
            var title: String
            var font: Font = .caption
            var color: Color = .gray
        }
    }

    struct Point: Identifiable {
        var id: UUID = UUID()
        var icon: Image = .init("checkmark", bundle: .module)
        var title: String
        var font: Font = .body
        var color: Color = .black
    }

    struct FooterLink: Identifiable, Hashable {
        var id: UUID = UUID()
        var title: String
        var titleFont: Font = .caption
        var titleColor: Color = .black
        var separatorSymbol: String = "•"
        var separatorSymbolColor: Color = Color.gray.opacity(0.7)
        var action: (() -> Void)
        
        func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
        
        static func == (lhs: IAPPaywallModel.FooterLink, rhs: IAPPaywallModel.FooterLink) -> Bool {
            lhs.id == rhs.id
        }
    }

    struct Plan: Identifiable, Hashable {
        var id: String
        var iconColor: Color = .black
        var title: Title
        var subTitle: SubTitle
        var promotion: Promo?
        var selectedBorderColor: Color = .black

        struct Title {
            var title: String
            var color: Color = .black
            var font: Font = .body.bold()
        }
        
        struct SubTitle {
            var title: String
            var color: Color = .black
            var font: Font = .body
        }
        
        struct Promo {
            var title: String
            var titleColor: Color = .white
            var font: Font = .caption
            var backgroundColor: Color? = .black
        }

        func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }

        static func == (lhs: IAPPaywallModel.Plan, rhs: IAPPaywallModel.Plan) -> Bool {
            lhs.id == rhs.id
        }
    }
}
