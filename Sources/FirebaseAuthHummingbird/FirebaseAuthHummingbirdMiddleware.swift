//
//  FirebaseAuthHummingbirdMiddleware.swift
//  FirebaseAuthKit
//
//  Created by Norikazu Muramoto on 2024/11/15.
//

import Hummingbird
import FirebaseAuthKit
import HTTPTypes

/// A Hummingbird middleware for authenticating requests using Firebase authentication tokens.
public struct FirebaseAuthHummingbirdMiddleware<Context: RequestContext>: RouterMiddleware {
    private let verifier: FirebaseAuthVerifier
    
    /// Initializes a new instance of `FirebaseAuthHummingbirdMiddleware`.
    public init(verifier: FirebaseAuthVerifier) {
        self.verifier = verifier
    }
    
    /// Processes the incoming request by verifying the Firebase authentication token.
    public func handle(
        _ request: Request,
        context: Context,
        next: (Request, Context) async throws -> Response
    ) async throws -> Response {
        // Extract bearer token from Authorization header
//        guard let authHeader = request.headers["authorization"].first,
//              authHeader.hasPrefix("Bearer "),
//              let token = authHeader.split(separator: " ").last.map(String.init) else {
//            throw HTTPError(.unauthorized)
//        }
//        
//        do {
//            // Verify the bearer token
//            let firebaseToken = try await verifier.verify(token)
//            
//            // Create and set the Firebase user
//            let user = FirebaseUser(
//                uid: firebaseToken.uid,
//                email: firebaseToken.email,
//                claims: firebaseToken.claims
//            )
//            request.auth.set(user)
//            
//            return try await next(request, context)
//        } catch {
//            throw HTTPError(.unauthorized)
//        }
        fatalError()
    }
}
