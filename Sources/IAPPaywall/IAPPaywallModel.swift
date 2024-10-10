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
    
    public init(
        title: Title,
        subTitle: SubTitle? = nil,
        header: Header,
        points: [Point]? = nil,
        payButton: PayButton,
        footerLinks: [FooterLink], 
        plans: [Plan]
    ) {
        self.title = title
        self.subTitle = subTitle
        self.header = header
        self.points = points
        self.payButton = payButton
        self.footerLinks = footerLinks
        self.plans = plans
    }

    public struct Title {
        var title: String
        var font: Font = .largeTitle.bold()
        var color: Color = .black

        public init(
            title: String,
            font: Font = .largeTitle.bold(),
            color: Color = .black
        ) {
            self.title = title
            self.font = font
            self.color = color
        }
    }

    public struct SubTitle {
        var subTitle: String
        var font: Font = .body
        var color: Color = .black
        
        public init(
            subTitle: String,
            font: Font = .body,
            color: Color = .black
        ) {
            self.subTitle = subTitle
            self.font = font
            self.color = color
        }
    }

    public struct Header {
        var title: String?
        var font: Font? = .body
        var color: Color? = .black
        var image: Image?
        var isSticky: Bool = true
        var isStretchy: Bool = true
        var shouldShowBlurNavBarOnScroll: Bool = true

        public init(
            title: String? = nil,
            font: Font? = .body,
            color: Color? = .black,
            image: Image? = nil,
            isSticky: Bool = true,
            isStretchy: Bool = true,
            shouldShowBlurNavBarOnScroll: Bool = true
        ) {
            self.title = title
            self.font = font
            self.color = color
            self.image = image
            self.isSticky = isSticky
            self.isStretchy = isStretchy
            self.shouldShowBlurNavBarOnScroll = shouldShowBlurNavBarOnScroll
        }
    }

    public struct PayButton {
        var title: String
        var titleColor: Color = .white
        var font: Font = .body
        var backgroundColor: Color = .black
        var caption: Caption?
        
        public init(
            title: String,
            titleColor: Color,
            font: Font, 
            backgroundColor: Color,
            caption: Caption? = nil
        ) {
            self.title = title
            self.titleColor = titleColor
            self.font = font
            self.backgroundColor = backgroundColor
            self.caption = caption
        }
        
        public struct Caption {
            var title: String
            var font: Font = .caption
            var color: Color = .gray
            
            public init(
                title: String,
                font: Font = .caption,
                color: Color = .gray
            ) {
                self.title = title
                self.font = font
                self.color = color
            }
        }
    }

    public struct Point: Identifiable {
        public var id: UUID = UUID()
        var icon: Image
        var title: String
        var font: Font = .body
        var color: Color = .black
        
        public init(
            icon: Image,
            title: String,
            font: Font = .body,
            color: Color = .black
        ) {
            self.icon = icon
            self.title = title
            self.font = font
            self.color = color
        }
    }

    public struct FooterLink: Identifiable, Hashable {
        public var id: UUID = UUID()
        var title: String
        var titleFont: Font = .caption
        var titleColor: Color = .black
        var separatorSymbol: String = "•"
        var separatorSymbolColor: Color = Color.gray.opacity(0.7)
        var action: (() -> Void)
        
        public init(
            title: String,
            titleFont: Font = .caption,
            titleColor: Color = .black,
            separatorSymbol: String = "•",
            separatorSymbolColor: Color = Color.gray.opacity(0.7),
            action: @escaping () -> Void
        ) {
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
        var iconColor: Color = .black
        var title: Title
        public var price: Double
        var subTitle: SubTitle
        var promotion: Promo?
        var borderColor: Color = .black
        var selectedBorderColor: Color = .black
        
        public init(
            id: String,
            iconColor: Color = .black,
            title: Title,
            subTitle: SubTitle,
            price: Double,
            promotion: Promo? = nil,
            borderColor: Color = .black,
            selectedBorderColor: Color = .black
        ) {
            self.id = id
            self.iconColor = iconColor
            self.title = title
            self.subTitle = subTitle
            self.price = price
            self.promotion = promotion
            self.borderColor = borderColor
            self.selectedBorderColor = selectedBorderColor
        }

        public struct Title {
            var title: String
            var color: Color = .black
            var font: Font = .body.bold()
            
            public init(
                title: String,
                color: Color = .black,
                font: Font = .body.bold()
            ) {
                self.title = title
                self.color = color
                self.font = font
            }
        }
        
        public struct SubTitle {
            var title: String
            var color: Color = .black
            var font: Font = .body
            
            public init(
                title: String,
                color: Color = .black,
                font: Font = .body
            ) {
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
            
            public init(
                title: String,
                titleColor: Color = .white,
                font: Font = .caption,
                backgroundColor: Color? = .black
            ) {
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
