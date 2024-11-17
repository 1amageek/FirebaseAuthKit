//
//  FirebaseConfig.swift
//  FirebaseAuthKit
//
//  Created by Norikazu Muramoto on 2024/11/15.
//

import Foundation

/// A configuration struct for Firebase authentication.
///
/// This struct holds essential Firebase project-specific details required
/// to verify authentication tokens.
public struct FirebaseConfig {
    /// The Firebase project ID.
    public let projectID: String
    
    /// The URL to fetch the public keys used for token verification.
    public let keysURL: String
        
    /// The current Firebase Auth environment
    public let environment: FirebaseAuthEnvironment
    
    /// Creates a new instance of `FirebaseConfig`.
    ///
    /// - Parameters:
    ///   - projectID: The Firebase project ID.
    ///   - environment: The Firebase Auth environment (default: determined by FIREBASE_AUTH_EMULATOR_HOST)
    ///   - keysURL: (Optional) The URL to fetch public keys.
    public init(
        projectID: String,
        environment: FirebaseAuthEnvironment = .current,
        keysURL: String = "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"
    ) {
        self.projectID = projectID
        self.keysURL = keysURL
        self.environment = environment
    }
    
}
