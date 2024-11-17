//
//  FirebaseAuthVerifier.swift
//  FirebaseAuthKit
//
//  Created by Norikazu Muramoto on 2024/11/15.
//

import NIO
import Foundation
import AsyncHTTPClient
import JWTKit

/// A service that verifies Firebase authentication tokens.
///
/// This actor is responsible for retrieving public keys from Firebase, verifying
/// the token's signature, and decoding its payload into a `FirebaseToken` object.
public actor FirebaseAuthVerifier {
    private let config: FirebaseConfig
    private let keyStore: KeyStore
    private var keys: JWTKeyCollection
    
    /// Initializes a new instance of `FirebaseAuthVerifier`.
    ///
    /// - Parameters:
    ///   - config: The Firebase configuration, containing project-specific details.
    ///   - httpClient: An `HTTPClient` instance used to fetch public keys.
    public init(config: FirebaseConfig, httpClient: HTTPClient) {
        self.config = config
        self.keyStore = KeyStore(
            httpClient: httpClient,
            keysURL: config.keysURL
        )
        self.keys = JWTKeyCollection()
    }
    
    /// Verifies the provided Firebase authentication token.
    ///
    /// - Parameter token: The JWT token to verify.
    /// - Returns: A `FirebaseToken` containing the decoded token payload.
    /// - Throws: An error if the token is invalid, expired, or verification fails.
    public func verify(_ token: String) async throws -> FirebaseToken {
        if FirebaseAuthEnvironment.current.useEmulator {
            if token == "owner" {
                return FirebaseToken(
                    uid: "owner",
                    email: "owner@example.com",
                    isEmailVerified: true,
                    claims: ["admin": "true"]
                )
            }
            let (_, payload) = try parseToken(token)
            try validateToken(payload)
            return FirebaseToken(
                uid: payload.sub,
                email: payload.email,
                isEmailVerified: payload.emailVerified,
                claims: payload.claims
            )
        }
        
        let kid = try extractKeyID(from: token)
        let publicKey = try await keyStore.getKey(kid)
        let payload = try await verifyAndDecode(token, with: publicKey, kid: kid)
        
        return FirebaseToken(
            uid: payload.sub,
            email: payload.email,
            isEmailVerified: payload.emailVerified,
            claims: payload.claims
        )
    }
    
    /// Extracts the Key ID (KID) from the JWT header.
    ///
    /// - Parameter token: The JWT token.
    /// - Returns: The Key ID as a string.
    /// - Throws: An error if the token is invalid or the KID is missing.
    private func extractKeyID(from token: String) throws -> String {
        let tokenParts = token.split(separator: ".")
        guard tokenParts.count == 3,
              let headerData = Data(base64Encoded: String(tokenParts[0])),
              let header = try? JSONDecoder().decode(JWTHeader.self, from: headerData),
              !header.kid.isEmpty else {
            throw FirebaseAuthError.invalidToken
        }
        return header.kid
    }
    
    /// Verifies and decodes the JWT token using the provided public key.
    ///
    /// - Parameters:
    ///   - token: The JWT token to verify.
    ///   - publicKey: The public key used for verification.
    ///   - kid: The Key ID associated with the token.
    /// - Returns: The decoded `FirebaseTokenPayload`.
    /// - Throws: An error if verification or decoding fails.
    private func verifyAndDecode(_ token: String, with publicKey: String, kid: String) async throws -> FirebaseTokenPayload {
        do {
            // Create an RSA public key
            let key = try Insecure.RSA.PublicKey(pem: publicKey)
            // Update the key collection
            await keys.add(rsa: key, digestAlgorithm: .sha256, kid: .init(string: kid))
            
            // Verify and decode the token
            let payload = try await keys.verify(token, as: FirebaseTokenPayload.self)
            try validateToken(payload)
            return payload
        } catch {
            throw FirebaseAuthError.verificationFailed
        }
    }
    
    /// Validates the decoded token payload against Firebase-specific rules.
    ///
    /// - Parameter payload: The decoded `FirebaseTokenPayload`.
    /// - Throws: An error if the token is expired or invalid.
    private func validateToken(_ payload: FirebaseTokenPayload) throws {
        let now = Date().timeIntervalSince1970
        
        guard payload.exp > now else {
            throw FirebaseAuthError.tokenExpired
        }
        
        guard payload.iat < now else {
            throw FirebaseAuthError.invalidToken
        }
        
        if !FirebaseAuthEnvironment.current.useEmulator {
            guard payload.iss == "https://securetoken.google.com/\(config.projectID)" else {
                throw FirebaseAuthError.invalidIssuer
            }
            
            guard payload.aud == config.projectID else {
                throw FirebaseAuthError.invalidAudience
            }
        }
    }
}

// MARK: - FirebaseTokenPayload Conformance

/// Conformance to `JWTPayload` for Firebase-specific token payloads.
extension FirebaseTokenPayload: JWTPayload {
    public func verify(using signer: some JWTAlgorithm) throws { }
}

// MARK: - Test

extension FirebaseAuthVerifier {
    internal func parseToken(_ token: String) throws -> (header: JWTHeader, payload: FirebaseTokenPayload) {
        let parts = token.split(separator: ".")
        guard parts.count == 3,
              let headerData = Data(base64Encoded: String(parts[0])),
              let payloadData = Data(base64Encoded: String(parts[1])) else {
            throw FirebaseAuthError.invalidToken
        }
        
        let header = try JSONDecoder().decode(JWTHeader.self, from: headerData)
        let payload = try JSONDecoder().decode(FirebaseTokenPayload.self, from: payloadData)
        return (header, payload)
    }
}
