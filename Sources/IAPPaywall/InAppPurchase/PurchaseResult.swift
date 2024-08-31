//
//  PurchaseResult.swift
//
//
//  Created by Lkoberidze on 17.02.24.
//

import Foundation
import StoreKit

public enum PurchaseResult {
    case success(Product.PurchaseResult?)
    case pending
    case userCancelled
    case unknownError
}
