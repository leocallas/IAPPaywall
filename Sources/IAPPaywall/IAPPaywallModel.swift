//
//  IAPPaywallModel.swift
//
//
//  Created by Lkoberidze on 15.02.24.
//

import SwiftUI

public struct IAPPaywallModel {
    var payButton: PayButton
    var footer: Footer?
    var plans: [Plan]
    var bullets: (titles: [String], font: Font, color: Color)
    var trial: Trial?

    public init(
        payButton: PayButton,
        footer: Footer? = nil,
        plans: [Plan],
        bullets: ([String], font: Font, color: Color) = ([], .body, .black),
        trial: Trial? = nil
    ) {
        self.payButton = payButton
        self.footer = footer
        self.plans = plans
        self.bullets = bullets
        self.trial = trial
    }

    public struct PayButton {
        /// Do not pass a Button as the pay button label — the action is already handled by the paywall.
        public let content: (_ isTrialEnabled: Bool) -> AnyView
        public let caption: ((_ isTrialEnabled: Bool) -> AnyView)?
        
        public init(
            content: @escaping (_: Bool) -> AnyView,
            caption: ((_: Bool) -> AnyView)? = nil
        ) {
            self.content = content
            self.caption = caption
        }
    }

    public struct Plan: Identifiable, Hashable {
        public var id: String
        var type: PlanType
        var content: ((_ data: PlanData) -> AnyView)?
        var promo: ((_ data: PlanData) -> AnyView)?

        public init(
            id: String,
            type: PlanType,
            content: ((_ data: PlanData) -> AnyView)?,
            promo: ((_ data: PlanData) -> AnyView)? = nil
        ) {
            self.id = id
            self.type = type
            self.content = content
            self.promo = promo
        }

        public struct PlanData {
            var price: String
            var yearWeeklyPrice: String
            var trialDuration: Int
            var isFreeTrialEnabled: Bool
            var isSelected: Bool
        }

        public func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }

        static public func == (lhs: IAPPaywallModel.Plan, rhs: IAPPaywallModel.Plan) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    public struct Footer {
        public var content: AnyView?
        public var restoreButtonColor: Color = .gray
        public var restoreButtonFont: Font = .caption
    }

    public struct Trial {
        public var isEnabled: Bool
        public var selectPlanOnToggle: PlanType?
        public var onTitle: String
        public var offTitle: String?
        public var titleColor: Color
        public var titleFont: Font
        public var toggleTintColor: Color
        public var background: AnyView?

        public init(
            isEnabled: Bool,
            selectPlanOnToggle: PlanType? = nil,
            onTitle: String,
            offTitle: String? = nil,
            titleColor: Color = .black,
            titleFont: Font = .title3,
            toggleTintColor: Color = .accentColor,
            background: AnyView? = nil
        ) {
            self.isEnabled = isEnabled
            self.selectPlanOnToggle = selectPlanOnToggle
            self.onTitle = onTitle
            self.offTitle = offTitle
            self.titleColor = titleColor
            self.titleFont = titleFont
            self.toggleTintColor = toggleTintColor
            self.background = background
        }
    }

    public enum PlanType {
        case weekly
        case monthly
        case yearly
    }
}
