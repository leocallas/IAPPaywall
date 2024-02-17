//
//  File.swift
//  
//
//  Created by Lkoberidze on 17.02.24.
//

import Foundation

enum PurchaseResult {
    case success(VerificationResult)
    case pending
    case userCancelled
    case unknownError
    
    enum VerificationResult {
        case verified
        case unverified(Error?)
    }
}
