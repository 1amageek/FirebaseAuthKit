//
//  FirebaseAuthEnvironment.swift
//  FirebaseAuthKit
//
//  Created by Norikazu Muramoto on 2024/11/17.
//

import Foundation

public enum FirebaseAuthEnvironment {
    case production
    case emulator(host: String)
    
    /// Get environment from environment variables
    public static var current: FirebaseAuthEnvironment {
        if let host = ProcessInfo.processInfo.environment["FIREBASE_AUTH_EMULATOR_HOST"] {
            return .emulator(host: host)
        }
        return .production
    }
    
    /// Determines if the emulator should be used
    public var useEmulator: Bool {
        switch self {
        case .production:
            return false
        case .emulator:
            return true
        }
    }
    
    /// Gets the base URL for Firebase Auth requests
    func baseURL(version: String, projectID: String, api: String) -> String {
        switch self {
        case .production:
            return FirebaseAuthConstants.firebaseAuthBaseURLFormat
                .replacingOccurrences(of: "{version}", with: version)
                .replacingOccurrences(of: "{projectID}", with: projectID)
                .replacingOccurrences(of: "{api}", with: api)
        case .emulator(let host):
            return FirebaseAuthConstants.firebaseAuthEmulatorBaseURLFormat
                .replacingOccurrences(of: "{host}", with: host)
                .replacingOccurrences(of: "{version}", with: version)
                .replacingOccurrences(of: "{projectID}", with: projectID)
                .replacingOccurrences(of: "{api}", with: api)
        }
    }
    
    /// Gets the tenant-specific base URL for Firebase Auth requests
    func tenantBaseURL(version: String, projectID: String, tenantId: String, api: String) -> String {
        switch self {
        case .production:
            return FirebaseAuthConstants.firebaseAuthTenantURLFormat
                .replacingOccurrences(of: "{version}", with: version)
                .replacingOccurrences(of: "{projectID}", with: projectID)
                .replacingOccurrences(of: "{tenantId}", with: tenantId)
                .replacingOccurrences(of: "{api}", with: api)
        case .emulator(let host):
            return FirebaseAuthConstants.firebaseAuthEmulatorTenantURLFormat
                .replacingOccurrences(of: "{host}", with: host)
                .replacingOccurrences(of: "{version}", with: version)
                .replacingOccurrences(of: "{projectID}", with: projectID)
                .replacingOccurrences(of: "{tenantId}", with: tenantId)
                .replacingOccurrences(of: "{api}", with: api)
        }
    }
}
