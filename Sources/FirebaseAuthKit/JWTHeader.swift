//
//  JWTHeader.swift
//  FirebaseAuthKit
//
//  Created by Norikazu Muramoto on 2024/11/15.
//

import Foundation

/// A structure representing the header of a JWT token.
struct JWTHeader: Codable, Sendable {
    /// The algorithm used to sign the token.
    let alg: String
    
    /// The Key ID associated with the token.
    let kid: String
    
    /// The type of the token, typically "JWT".
    let typ: String
}

/// A structure representing the payload of a Firebase authentication token.
///
/// This struct contains information such as the token issuer, audience, and user-related details.
public struct FirebaseTokenPayload: Codable, Sendable {
    /// The issuer of the token.
    let iss: String
    
    /// The audience for which the token is intended.
    let aud: String
    
    /// The time the user authenticated, in seconds since the Unix epoch.
    let auth_time: Int
    
    /// The unique identifier for the user.
    let user_id: String
    
    /// The subject of the token, typically identical to the user ID.
    let sub: String
    
    /// The time the token was issued, in seconds since the Unix epoch.
    let iat: TimeInterval
    
    /// The time the token expires, in seconds since the Unix epoch.
    let exp: TimeInterval
    
    /// The email address associated with the user, if available.
    let email: String?
    
    /// A Boolean indicating whether the user's email is verified.
    let emailVerified: Bool?
    
    /// A dictionary of custom claims included in the token, if any.
    let claims: [String: String]?
    
    /// Firebase-specific data included in the token payload.
    let firebase: FirebaseData
    
    /// A nested structure representing Firebase-specific data.
    struct FirebaseData: Codable, Sendable {
        /// A dictionary of user identities associated with different providers.
        let identities: [String: [String]]
        
        /// The sign-in provider used for the authentication.
        let sign_in_provider: String
    }
}
