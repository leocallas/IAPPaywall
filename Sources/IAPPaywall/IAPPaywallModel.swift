//
//  IAPPaywallModel.swift
//
//
//  Created by Lkoberidze on 15.02.24.
//

import SwiftUI

public struct IAPPaywallModel {
    var isStretchy = true
    var isSticky = true
    var payButton: PayButton
    var footerLinks: [FooterLink] = []
    var plans: [Plan]
    var bullets: (titles: [String], font: Font, color: Color)
    var trial: Trial?

    public init(
        isStretchy: Bool = false,
        isSticky: Bool = true,
        payButton: PayButton,
        footerLinks: [FooterLink], 
        plans: [Plan],
        bullets: ([String], font: Font, color: Color) = ([], .body, .black),
        trial: Trial? = nil
    ) {
        self.isStretchy = isStretchy
        self.isSticky = isSticky
        self.payButton = payButton
        self.footerLinks = footerLinks
        self.plans = plans
        self.bullets = bullets
        self.trial = trial
    }

    public struct PayButton {
        /// Do not pass a Button as the pay button label — the action is already handled by the paywall.
        public let labelBuilder: () -> AnyView
        public let caption: Caption?

        public init<Content: View>(
            @ViewBuilder label: @escaping () -> Content,
            caption: Caption? = nil
        ) {
            self.labelBuilder = { AnyView(label()) }
            self.caption = caption
        }
        
        public struct Caption {
            var title: String
            var font: Font = .caption
            var color: Color = .gray
            var icon: Image?
            var iconTint: Color?
            
            public init(
                title: String,
                font: Font = .caption,
                color: Color = .gray,
                icon: Image? = nil,
                iconTint: Color? = nil
            ) {
                self.title = title
                self.font = font
                self.color = color
                self.icon = icon
                self.iconTint = iconTint
            }
        }
        
        public func makeWrappedButton(
            action: @escaping () -> Void
        ) -> some View {
            Button(action: action) {
                labelBuilder()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .padding(.horizontal, 15)
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
        var type: PlanType
        var checkmarkIconColor: Color = .black
        var title: Title
        var subTitle: SubTitle?
        var rightTitle: Title?
        var promotion: Promo?
        var borderColor: Color = .black
        var selectedBorderColor: Color = .black
        
        public init(
            id: String,
            type: PlanType,
            checkmarkIconColor: Color = .black,
            title: Title,
            subTitle: SubTitle? = nil,
            rightTitle: Title? = nil,
            promotion: Promo? = nil,
            borderColor: Color = .black,
            selectedBorderColor: Color = .black
        ) {
            self.id = id
            self.type = type
            self.checkmarkIconColor = checkmarkIconColor
            self.title = title
            self.subTitle = subTitle
            self.rightTitle = rightTitle
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
    
    public struct Trial {
        public var isEnabled: Bool
        public var overridePlan: OverridePlan?
        public var shouldSelectOverridePlan = true
        public var payButtonTitleOverride: String?
        public var payButtonCaptionOverride: String?
        public var onTitle: String
        public var offTitle: String?
        public var titleColor: Color
        public var titleFont: Font
        public var toggleTintColor: Color
        public var borderColor: Color

        public init(
            isEnabled: Bool,
            overridePlan: OverridePlan? = nil,
            shouldSelectOverridePlan: Bool = true,
            payButtonTitleOverride: String? = nil,
            payButtonCaptionOverride: String? = nil,
            onTitle: String,
            offTitle: String? = nil,
            titleColor: Color = .black,
            titleFont: Font = .title3,
            toggleTintColor: Color = .accentColor,
            borderColor: Color = .black
        ) {
            self.isEnabled = isEnabled
            self.overridePlan = overridePlan
            self.shouldSelectOverridePlan = shouldSelectOverridePlan
            self.payButtonTitleOverride = payButtonTitleOverride
            self.payButtonCaptionOverride = payButtonCaptionOverride
            self.onTitle = onTitle
            self.offTitle = offTitle
            self.titleColor = titleColor
            self.titleFont = titleFont
            self.toggleTintColor = toggleTintColor
            self.borderColor = borderColor
        }
        
        public struct OverridePlan {
            var title: String?
            var subtitle: String?
            var rightTitle: String?
            var planToOverride: PlanType
            
            public init(
                planToOverride: PlanType,
                title: String? = nil,
                subtitle: String? = nil,
                rightTitle: String? = nil
            ) {
                self.planToOverride = planToOverride
                self.title = title
                self.subtitle = subtitle
                self.rightTitle = rightTitle
            }
        }
    }

    public enum PlanType {
        case weekly
        case monthly
        case yearly
    }
}
