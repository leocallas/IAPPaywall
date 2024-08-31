//
//  PurchaseResult.swift
//
//
//  Created by Lkoberidze on 17.02.24.
//

import Foundation
import StoreKit

public enum PurchaseResult {
    case success(VerificationResult)
    case pending
    case userCancelled
    case unknownError
    
    public enum VerificationResult {
        case verified(Transaction)
        case unverified(Transaction, Error?)
    }
}
