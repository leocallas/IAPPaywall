//
//  IAPPaywallModel.swift
//
//
//  Created by Lkoberidze on 15.02.24.
//

import SwiftUI

public struct IAPPaywallModel {
    public var title: Title
    public var subTitle: SubTitle?
    public var header: Header
    public var points: [Point]?
    public var payButton: PayButton
    public var footerLinks: [FooterLink] = []
    public var plans: [Plan]
    
    public struct Title {
        public var title: String
        public var font: Font = .largeTitle.bold()
        public var color: Color = .black
    }

    public struct SubTitle {
        public var subTitle: String
        public var font: Font = .body
        public var color: Color = .black
    }

    public struct Header {
        public var title: String
        public var font: Font = .body
        public var color: Color = .black
        public var image: Image?
        public var isSticky: Bool = true
        public var isStretchy: Bool = true
    }

    public struct PayButton {
        public var title: String
        public var titleColor: Color = .white
        public var font: Font = .body
        public var backgroundColor: Color = .black
        public var caption: Caption?
        
        public struct Caption {
            public var title: String
            public var font: Font = .caption
            public var color: Color = .gray
        }
    }

    public struct Point: Identifiable {
        public var id: UUID = UUID()
        public var icon: Image = .init("checkmark", bundle: .module)
        public var title: String
        public var font: Font = .body
        public var color: Color = .black
    }

    public struct FooterLink: Identifiable, Hashable {
        public var id: UUID = UUID()
        public var title: String
        public var titleFont: Font = .caption
        public var titleColor: Color = .black
        public var separatorSymbol: String = "•"
        public var separatorSymbolColor: Color = Color.gray.opacity(0.7)
        public var action: (() -> Void)
        
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
        
        static public func == (lhs: IAPPaywallModel.FooterLink, rhs: IAPPaywallModel.FooterLink) -> Bool {
            lhs.id == rhs.id
        }
    }

    public struct Plan: Identifiable, Hashable {
        public var id: String
        public var iconColor: Color = .black
        public var title: Title
        public var subTitle: SubTitle
        public var promotion: Promo?
        public var selectedBorderColor: Color = .black

        public struct Title {
            var title: String
            var color: Color = .black
            var font: Font = .body.bold()
        }
        
        public struct SubTitle {
            var title: String
            var color: Color = .black
            var font: Font = .body
        }
        
        public struct Promo {
            var title: String
            var titleColor: Color = .white
            var font: Font = .caption
            var backgroundColor: Color? = .black
        }

        public func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }

        static public func == (lhs: IAPPaywallModel.Plan, rhs: IAPPaywallModel.Plan) -> Bool {
            lhs.id == rhs.id
        }
    }
}
