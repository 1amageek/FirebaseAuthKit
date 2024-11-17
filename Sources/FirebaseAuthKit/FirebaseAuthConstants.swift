//
//  FirebaseAuthConstants.swift
//  FirebaseAuthKit
//
//  Created by Norikazu Muramoto on 2024/11/17.
//


struct FirebaseAuthConstants {
    static let maxClaimsPayloadSize = 1000
    static let maxDownloadAccountPageSize = 1000
    static let maxUploadAccountBatchSize = 1000
    static let maxGetAccountsBatchSize = 100
    static let maxDeleteAccountsBatchSize = 1000
    static let minSessionCookieDurationSecs = 5 * 60
    static let maxSessionCookieDurationSecs = 14 * 24 * 60 * 60
    static let maxListProviderConfigurationPageSize = 100
    static let firebaseAuthBaseURLFormat = "https://identitytoolkit.googleapis.com/{version}/projects/{projectId}{api}"
    static let firebaseAuthEmulatorBaseURLFormat = "http://{host}/identitytoolkit.googleapis.com/{version}/projects/{projectId}{api}"
    static let firebaseAuthTenantURLFormat = "https://identitytoolkit.googleapis.com/{version}/projects/{projectId}/tenants/{tenantId}{api}"
    static let firebaseAuthEmulatorTenantURLFormat = "http://{host}/identitytoolkit.googleapis.com/{version}/projects/{projectId}/tenants/{tenantId}{api}"
    static let maxListTenantPageSize = 1000
}