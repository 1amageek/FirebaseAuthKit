# 🔥 FirebaseAuthKit

🚀 A Swift server-side library for seamless Firebase Authentication integration, with first-class support for Vapor and Hummingbird frameworks.

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Vapor](https://img.shields.io/badge/Vapor-4.0-blue.svg)](https://vapor.codes)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)

## ✨ Features

- 🔒 Secure Firebase ID token verification
- ⚡️ Efficient public key management with caching
- 🌐 Built-in Vapor middleware
- 🧩 Modular design for easy integration
- 🎯 Swift Concurrency support out of the box
- 🔄 Automatic key rotation handling
- 🧪 Firebase Auth Emulator support

## 📋 Requirements

- 💻 Swift 6.0+
- 🍎 macOS 15.0+ / iOS 18.0+
- ⚙️ Xcode 15.0+

## 📦 Installation

### Swift Package Manager

Add this to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/1amageek/firebase-auth-kit.git", from: "1.0.0")
]
```

And include it in your target:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["FirebaseAuthKit"]
    )
]
```

## 🚀 Quick Start

### Production Setup

```swift
import FirebaseAuthKit
import AsyncHTTPClient

// Initialize HTTP client
let httpClient = HTTPClient(eventLoopGroupProvider: .singleton)

// Configure Firebase for production
let config = FirebaseConfig(
    projectId: "your-project-id",
    apiKey: "your-api-key"
)

// Create the verifier
let verifier = FirebaseAuthVerifier(config: config, httpClient: httpClient)
```

### Local Development with Emulator

1. First, set up Firebase Auth Emulator in your `.env`:
```env
FIREBASE_AUTH_EMULATOR_HOST=localhost:9099
```

2. Load the environment variable in your app:
```swift
import Foundation
import FirebaseAuthKit
import AsyncHTTPClient

// Environment variables will be automatically detected
let config = FirebaseConfig(
    projectId: "demo-project",
    apiKey: "demo-key"
)

// Or explicitly specify emulator
let config = FirebaseConfig(
    projectId: "demo-project",
    apiKey: "demo-key",
    environment: .emulator(host: "localhost:9099")
)

let verifier = FirebaseAuthVerifier(config: config, httpClient: httpClient)
```

### 🌐 Vapor Integration

```swift
import Vapor
import FirebaseAuthVapor

// Configure Vapor app
let app = try Application(.detect())
defer { app.shutdown() }

// Setup HTTPClient
let httpClient = HTTPClient(eventLoopGroupProvider: .singleton)
defer { try? httpClient.syncShutdown() }

// Setup Firebase config (automatically detects emulator from environment)
let config = FirebaseConfig(
    projectId: "your-project-id",
    apiKey: "your-api-key"
)

// Create verifier
let verifier = FirebaseAuthVerifier(config: config, httpClient: httpClient)

// Set up Firebase Auth middleware
let authMiddleware = FirebaseAuthVaporMiddleware(verifier: verifier)

// Create protected routes
let protected = app.grouped(authMiddleware)

protected.get("profile") { req -> String in
    guard let user = req.auth.get(FirebaseUser.self) else {
        throw Abort(.unauthorized)
    }
    return "👋 Welcome, \(user.uid)!"
}

try app.run()
```

## 🧪 Testing with Firebase Auth Emulator

1. Start the Firebase Emulator:
```bash
firebase emulators:start
```

2. Set environment variable:
```bash
export FIREBASE_AUTH_EMULATOR_HOST=localhost:9099
```

3. Special testing features in emulator mode:
```swift
// Use "owner" token for admin access in tests
let ownerToken = "owner"
let verifiedToken = try await verifier.verify(ownerToken)
// Returns a token with admin claims

// Regular tokens in emulator mode skip signature verification
let testToken = "test.token.signature"
let verifiedTestToken = try await verifier.verify(testToken)
```

## ⚠️ Error Handling

FirebaseAuthKit provides clear error cases:

```swift
enum FirebaseAuthError: Error {
    case invalidToken       // ❌ Token format is invalid
    case missingToken      // 🚫 Token not found
    case tokenExpired      // ⏰ Token has expired
    case invalidIssuer     // 🔒 Invalid token issuer
    case invalidAudience   // 👥 Invalid token audience
    case verificationFailed // 💥 Verification process failed
}
```

## 💡 Best Practices

1. 🔄 **Share HTTP Client**: Use a single HTTPClient instance across your application
2. 🎯 **Error Handling**: Properly handle all verification errors
3. 🛑 **Shutdown Management**: Properly shutdown HTTPClient when your application terminates
4. 🔒 **Security**: Always validate tokens on the server side
5. ⚡️ **Performance**: Utilize the built-in caching mechanism for optimal performance
6. 🧪 **Testing**: Use Firebase Auth Emulator for local development and testing

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Made with ❤️ by [1amageek](https://x.com/1amageek)
