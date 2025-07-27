//
//  CachedProduct.swift
//  IAPPaywall
//
//  Created by LKoberidze on 15.07.25.
//

import Foundation

public struct CachedProduct: Codable {
    let id: String
    let localizedPrice: String
    let formattedYearWeeklyPrice: String?
    let trialDuration: Int?
}
