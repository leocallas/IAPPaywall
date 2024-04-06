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
    
    public init(title: Title, subTitle: SubTitle? = nil, header: Header, points: [Point]? = nil, payButton: PayButton, footerLinks: [FooterLink], plans: [Plan]) {
        self.title = title
        self.subTitle = subTitle
        self.header = header
        self.points = points
        self.payButton = payButton
        self.footerLinks = footerLinks
        self.plans = plans
    }

    public struct Title {
        public var title: String
        public var font: Font = .largeTitle.bold()
        public var color: Color = .black

        public init(title: String, font: Font, color: Color) {
            self.title = title
            self.font = font
            self.color = color
        }
    }

    public struct SubTitle {
        public var subTitle: String
        public var font: Font = .body
        public var color: Color = .black
        
        public init(subTitle: String, font: Font, color: Color) {
            self.subTitle = subTitle
            self.font = font
            self.color = color
        }
    }

    public struct Header {
        public var title: String
        public var font: Font = .body
        public var color: Color = .black
        public var image: Image?
        public var isSticky: Bool = true
        public var isStretchy: Bool = true
        
        public init(title: String, font: Font, color: Color, image: Image? = nil, isSticky: Bool, isStretchy: Bool) {
            self.title = title
            self.font = font
            self.color = color
            self.image = image
            self.isSticky = isSticky
            self.isStretchy = isStretchy
        }
    }

    public struct PayButton {
        public var title: String
        public var titleColor: Color = .white
        public var font: Font = .body
        public var backgroundColor: Color = .black
        public var caption: Caption?
        
        public init(title: String, titleColor: Color, font: Font, backgroundColor: Color, caption: Caption? = nil) {
            self.title = title
            self.titleColor = titleColor
            self.font = font
            self.backgroundColor = backgroundColor
            self.caption = caption
        }
        
        public struct Caption {
            public var title: String
            public var font: Font = .caption
            public var color: Color = .gray
            
            public init(title: String, font: Font, color: Color) {
                self.title = title
                self.font = font
                self.color = color
            }
        }
    }

    public struct Point: Identifiable {
        public var id: UUID = UUID()
        public var icon: Image = .init("checkmark", bundle: .module)
        public var title: String
        public var font: Font = .body
        public var color: Color = .black
        
        public init(id: UUID, icon: Image, title: String, font: Font, color: Color) {
            self.id = id
            self.icon = icon
            self.title = title
            self.font = font
            self.color = color
        }
    }

    public struct FooterLink: Identifiable, Hashable {
        public var id: UUID = UUID()
        public var title: String
        public var titleFont: Font = .caption
        public var titleColor: Color = .black
        public var separatorSymbol: String = "•"
        public var separatorSymbolColor: Color = Color.gray.opacity(0.7)
        public var action: (() -> Void)
        
        public init(id: UUID, title: String, titleFont: Font, titleColor: Color, separatorSymbol: String, separatorSymbolColor: Color, action: @escaping () -> Void) {
            self.id = id
            self.title = title
            self.titleFont = titleFont
            self.titleColor = titleColor
            self.separatorSymbol = separatorSymbol
            self.separatorSymbolColor = separatorSymbolColor
            self.action = action
        }
        
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
        
        public init(id: String, iconColor: Color, title: Title, subTitle: SubTitle, promotion: Promo? = nil, selectedBorderColor: Color) {
            self.id = id
            self.iconColor = iconColor
            self.title = title
            self.subTitle = subTitle
            self.promotion = promotion
            self.selectedBorderColor = selectedBorderColor
        }

        public struct Title {
            var title: String
            var color: Color = .black
            var font: Font = .body.bold()
            
            public init(title: String, color: Color, font: Font) {
                self.title = title
                self.color = color
                self.font = font
            }
        }
        
        public struct SubTitle {
            var title: String
            var color: Color = .black
            var font: Font = .body
            
            public init(title: String, color: Color, font: Font) {
                self.title = title
                self.color = color
                self.font = font
            }
        }
        
        public struct Promo {
            var title: String
            var titleColor: Color = .white
            var font: Font = .caption
            var backgroundColor: Color? = .black
            
            public init(title: String, titleColor: Color, font: Font, backgroundColor: Color? = nil) {
                self.title = title
                self.titleColor = titleColor
                self.font = font
                self.backgroundColor = backgroundColor
            }
        }

        public func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }

        static public func == (lhs: IAPPaywallModel.Plan, rhs: IAPPaywallModel.Plan) -> Bool {
            lhs.id == rhs.id
        }
    }
}
