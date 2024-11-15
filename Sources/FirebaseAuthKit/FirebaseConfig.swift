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
    public let projectId: String
    
    /// The API key for the Firebase project.
    public let apiKey: String
    
    /// The URL to fetch the public keys used for token verification.
    public let keysURL: String
    
    /// Creates a new instance of `FirebaseConfig`.
    ///
    /// - Parameters:
    ///   - projectId: The Firebase project ID.
    ///   - apiKey: The API key for the Firebase project.
    ///   - keysURL: (Optional) The URL to fetch public keys. Defaults to Firebase's standard keys URL.
    public init(
        projectId: String,
        apiKey: String,
        keysURL: String = "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"
    ) {
        self.projectId = projectId
        self.apiKey = apiKey
        self.keysURL = keysURL
    }
}
