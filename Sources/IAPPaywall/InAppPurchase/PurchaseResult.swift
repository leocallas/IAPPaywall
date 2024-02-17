//
//  File.swift
//  
//
//  Created by Lkoberidze on 17.02.24.
//

import Foundation

public enum PurchaseResult {
    case success(VerificationResult)
    case pending
    case userCancelled
    case unknownError
    
    public enum VerificationResult {
        case verified
        case unverified(Error?)
    }
}
