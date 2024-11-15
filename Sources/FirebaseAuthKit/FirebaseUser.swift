//
//  FirebaseUser.swift
//  FirebaseAuthKit
//
//  Created by Norikazu Muramoto on 2024/11/15.
//

import Foundation

/// A structure representing a Firebase authenticated user.
///
/// This struct encapsulates the user's unique identifier, email address,
/// and additional custom claims provided in the authentication token.
public struct FirebaseUser: Sendable {
    /// The unique identifier for the user.
    public let uid: String
    
    /// The email address associated with the user, if available.
    public let email: String?
    
    /// A dictionary of custom claims associated with the user, if any.
    public let claims: [String: String]?
    
    /// Initializes a new instance of `FirebaseUser`.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier for the user.
    ///   - email: The email address associated with the user, if available.
    ///   - claims: (Optional) A dictionary of custom claims associated with the user.
    public init(
        uid: String,
        email: String?,
        claims: [String: String]? = nil
    ) {
        self.uid = uid
        self.email = email
        self.claims = claims
    }
}
