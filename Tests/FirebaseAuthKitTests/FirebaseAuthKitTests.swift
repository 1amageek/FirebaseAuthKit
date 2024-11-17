import Testing
import Foundation
import JWTKit
import AsyncHTTPClient
@testable import FirebaseAuthKit

@Test("FirebaseUser stores properties correctly")
func testFirebaseUser() {
    let user = FirebaseUser(
        uid: "test-uid",
        email: "test@example.com",
        claims: ["role": "admin"]
    )
    
    #expect(user.uid == "test-uid")
    #expect(user.email == "test@example.com")
    #expect(user.claims?["role"] == "admin")
}

@Test("KeyStore caches and retrieves keys")
func testKeyStore() async throws {
    let httpClient = HTTPClient(eventLoopGroupProvider: .singleton)
    let keyStore = KeyStore(
        httpClient: httpClient,
        keysURL: "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"
    )
    
    // テスト用のキーをセット
    let testKeys = ["test-kid": "test-key-data"]
    keyStore.setCachedKeys(testKeys)
    
    // キャッシュされたキーを取得
    let cachedKeys = keyStore.cachedKeys
    #expect(cachedKeys["test-kid"] == "test-key-data")
    try await httpClient.shutdown()
}

@Test("FirebaseAuthVerifier parses valid token")
func testFirebaseAuthVerifierParsing() async throws {
    let config = FirebaseConfig(
        projectID: "test-project"
    )
    
    let httpClient = HTTPClient(eventLoopGroupProvider: .singleton)
    
    let verifier = FirebaseAuthVerifier(config: config, httpClient: httpClient)
    
    // 有効なトークン形式の文字列を作成
    let header = """
    {
        "alg": "RS256",
        "kid": "test-kid",
        "typ": "JWT"
    }
    """
    let payload = """
    {
        "iss": "https://securetoken.google.com/test-project",
        "aud": "test-project",
        "auth_time": 1699947600,
        "user_id": "test-uid",
        "sub": "test-uid",
        "iat": 1699947600,
        "exp": 1699951200,
        "email": "test@example.com",
        "email_verified": true,
        "firebase": {
            "identities": {
                "email": ["test@example.com"]
            },
            "sign_in_provider": "password"
        }
    }
    """
    
    let headerBase64 = Data(header.utf8).base64EncodedString()
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
    
    let payloadBase64 = Data(payload.utf8).base64EncodedString()
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
    
    let token = "\(headerBase64).\(payloadBase64).signature"
    
    // トークンのパースをテスト
    let (parsedHeader, parsedPayload) = try await verifier.parseToken(token)
    
    #expect(parsedHeader.kid == "test-kid")
    #expect(parsedPayload.email == "test@example.com")
    #expect(parsedPayload.sub == "test-uid")
    try await httpClient.shutdown()
}

@Test("FirebaseAuthVerifier rejects invalid token format")
func testFirebaseAuthVerifierInvalidToken() async throws {
    let config = FirebaseConfig(
        projectID: "test-project"
    )
    
    let httpClient = HTTPClient(eventLoopGroupProvider: .singleton)
    let verifier = FirebaseAuthVerifier(config: config, httpClient: httpClient)
    
    do {
        _ = try await verifier.parseToken("invalid.token")
        #expect(false, "Expected to throw invalid token error")
    } catch let error as FirebaseAuthError {
        #expect(error == .invalidToken)
    }
    try await httpClient.shutdown()
}
