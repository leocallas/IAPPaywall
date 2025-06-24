//
//  Product+.swift
//  IAPPaywall
//
//  Created by Lkoberidze on 13.06.25.
//

import StoreKit

extension Product {
    var localizedPrice: String {
        price.formatted(priceFormatStyle)
    }
    
    var formattedYearWeeklyPrice: String? {
        let weekly = price / 52
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceFormatStyle.locale
        return formatter.string(from: weekly as NSDecimalNumber)
    }
    
    var trialDuration: Int? {
        guard let offer = subscription?.introductoryOffer else { return nil }
        return offer.period.value
    }
}
