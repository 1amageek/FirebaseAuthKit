//
//  FirebaseToken.swift
//  FirebaseAuthKit
//
//  Created by Norikazu Muramoto on 2024/11/15.
//

import Foundation

/// A structure representing a decoded Firebase authentication token.
///
/// This struct includes information about the user, such as their unique identifier,
/// email address, email verification status, and any additional custom claims.
public struct FirebaseToken: Codable, Sendable {
    /// The unique identifier for the user.
    public let uid: String
    
    /// The email address associated with the user, if available.
    public let email: String?
    
    /// A Boolean indicating whether the user's email address has been verified.
    public let isEmailVerified: Bool?
    
    /// A dictionary of custom claims associated with the user, if any.
    public let claims: [String: String]?
    
    /// Initializes a new instance of `FirebaseToken`.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier for the user.
    ///   - email: The email address associated with the user, if available.
    ///   - isEmailVerified: A Boolean indicating whether the email is verified.
    ///   - claims: (Optional) A dictionary of custom claims associated with the user.
    public init(
        uid: String,
        email: String?,
        isEmailVerified: Bool?,
        claims: [String: String]? = nil
    ) {
        self.uid = uid
        self.email = email
        self.isEmailVerified = isEmailVerified
        self.claims = claims
    }
}
