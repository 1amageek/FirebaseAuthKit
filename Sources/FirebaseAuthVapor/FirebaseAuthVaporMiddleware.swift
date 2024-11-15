//
//  FirebaseAuthVaporMiddleware.swift
//  FirebaseAuthKit
//
//  Created by Norikazu Muramoto on 2024/11/15.
//

import Vapor
import FirebaseAuthKit

/// A Vapor middleware for authenticating requests using Firebase authentication tokens.
///
/// This middleware verifies the bearer token in the request headers, decodes it using
/// the `FirebaseAuthVerifier`, and authenticates the user in the request context.
public struct FirebaseAuthVaporMiddleware: AsyncMiddleware {
    private let verifier: FirebaseAuthVerifier
    
    /// Initializes a new instance of `FirebaseAuthVaporMiddleware`.
    ///
    /// - Parameter verifier: The `FirebaseAuthVerifier` used to verify Firebase authentication tokens.
    public init(verifier: FirebaseAuthVerifier) {
        self.verifier = verifier
    }
    
    /// Processes the incoming request by verifying the Firebase authentication token.
    ///
    /// - Parameters:
    ///   - request: The incoming `Request` object.
    ///   - next: The next responder in the middleware chain.
    /// - Returns: A `Response` object if the token is valid.
    /// - Throws: `FirebaseAuthError.missingToken` if no bearer token is provided, or
    ///           `FirebaseAuthError.verificationFailed` if the token is invalid or verification fails.
    public func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        // Ensure the bearer token is present in the headers.
        guard let bearer = request.headers.bearerAuthorization else {
            throw FirebaseAuthError.missingToken
        }
        
        do {
            // Verify the bearer token using the provided verifier.
            let token = try await verifier.verify(bearer.token)
            
            // Create a `FirebaseUser` from the token payload and log in the user.
            let user = FirebaseUser(
                uid: token.uid,
                email: token.email,
                claims: token.claims
            )
            request.auth.login(user)
            
            // Pass the request to the next middleware in the chain.
            return try await next.respond(to: request)
        } catch {
            // Handle any verification failure.
            throw FirebaseAuthError.verificationFailed
        }
    }
}

// MARK: - Authenticatable Conformance

/// Conformance of `FirebaseUser` to Vapor's `Authenticatable` protocol.
///
/// This allows `FirebaseUser` instances to be used with Vapor's authentication system.
extension FirebaseUser: Authenticatable { }
