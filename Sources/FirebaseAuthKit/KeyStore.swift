import Foundation
import AsyncHTTPClient
import NIOHTTP1
import NIOFoundationCompat
import Synchronization

/// A thread-safe key store using Mutex for state management.
final class KeyStore: Sendable {
    private let certificates: Mutex<[String: String]>
    private let lastFetchTime: Mutex<Date?>
    private let maxKeys: Int
    private let validityDuration: TimeInterval
    private let httpClient: HTTPClient
    private let keysURL: String
    
    enum KeyStoreError: Error {
        case invalidResponse
        case decodingFailed
        case keyNotFound
        case networkError(underlying: Error)
    }
    
    init(
        httpClient: HTTPClient,
        maxKeys: Int = 100,
        validityDuration: TimeInterval = 3600,
        keysURL: String
    ) {
        self.certificates = Mutex([:])
        self.lastFetchTime = Mutex(nil)
        self.maxKeys = maxKeys
        self.validityDuration = validityDuration
        self.httpClient = httpClient
        self.keysURL = keysURL
    }
    
    /// Retrieves a public key for the given key ID.
    ///
    /// - Parameter keyId: The ID of the key to retrieve.
    /// - Returns: The public key as a string.
    /// - Throws: An error if the key is not found or if the refresh fails.
    func getKey(_ keyId: String) async throws -> String {
        // Attempt to fetch the key from the cache.
        if certificates.withLock({ $0[keyId] }) != nil, !shouldRefresh() {
            return certificates.withLock { $0[keyId]! }
        }
        
        // Refresh keys if necessary.
        try await refresh()
        
        // Attempt to fetch the key again after refreshing.
        guard let key = certificates.withLock({ $0[keyId] }) else {
            throw KeyStoreError.keyNotFound
        }
        return key
    }
    
    /// Determines whether the key cache should be refreshed.
    ///
    /// - Returns: `true` if the cache is expired or uninitialized; otherwise, `false`.
    private func shouldRefresh() -> Bool {
        return lastFetchTime.withLock { lastFetch in
            guard let lastFetch = lastFetch else {
                return true
            }
            return Date().timeIntervalSince(lastFetch) > validityDuration
        }
    }
    
    /// Fetches and updates the key cache from the remote URL.
    ///
    /// - Throws: An error if the refresh fails, such as due to network or decoding issues.
    private func refresh() async throws {
        do {
            var request = HTTPClientRequest(url: keysURL)
            request.method = .GET
            request.headers.add(name: "Accept", value: "application/json")
            
            let response = try await httpClient.execute(request, timeout: .seconds(30))
            
            guard response.status == .ok else {
                throw KeyStoreError.invalidResponse
            }
            
            let body = try await response.body.collect(upTo: 1024 * 1024)
            let keys = try JSONDecoder().decode([String: String].self, from: body)
            let limitedKeys = Dictionary(Array(keys.prefix(maxKeys)), uniquingKeysWith: { first, _ in first })
            
            // Update certificates and fetch time in a thread-safe manner.
            certificates.withLock { $0 = limitedKeys }
            lastFetchTime.withLock { $0 = Date() }
        } catch is DecodingError {
            throw KeyStoreError.decodingFailed
        } catch let error as KeyStoreError {
            throw error
        } catch {
            // Handle network errors only if the cache is empty.
            if certificates.withLock({ $0.isEmpty }) {
                throw KeyStoreError.networkError(underlying: error)
            }
        }
    }
}
