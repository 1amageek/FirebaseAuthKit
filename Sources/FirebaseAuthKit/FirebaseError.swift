//
//  FirebaseError.swift
//  FirebaseAuthKit
//
//  Created by Norikazu Muramoto on 2024/11/15.
//

import Foundation

/// An enumeration of errors that can occur during Firebase authentication token verification.
public enum FirebaseAuthError: Error {
    /// The token format is invalid.
    case invalidToken
    
    /// The token is missing.
    case missingToken
    
    /// The token has expired.
    case tokenExpired
    
    /// The issuer of the token is invalid.
    case invalidIssuer
    
    /// The audience of the token is invalid.
    case invalidAudience
    
    /// Verification failed, including signature verification or decoding errors.
    case verificationFailed
}
