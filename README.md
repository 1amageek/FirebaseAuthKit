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

## 📋 Requirements

- 💻 Swift 6.0+
- 🍎 macOS 15.0+ / iOS 18.0+
- ⚙️ Xcode 15.0+

## 📦 Installation

### Swift Package Manager

Add this to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/firebase-auth-kit.git", from: "1.0.0")
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

### Basic Setup

```swift
import FirebaseAuthKit
import AsyncHTTPClient

// Initialize HTTP client
let httpClient = HTTPClient(eventLoopGroupProvider: .singleton)

// Configure Firebase
let config = FirebaseConfig(
    projectId: "your-project-id",
    apiKey: "your-api-key"
)

// Create the verifier
let verifier = FirebaseAuthVerifier(config: config, httpClient: httpClient)
```

### Token Verification

```swift
let token = "firebase-id-token"

do {
    let verifiedToken = try await verifier.verify(token)
    print("✅ Verified user ID: \(verifiedToken.uid)")
    print("📧 Email: \(verifiedToken.email ?? "Not available")")
} catch {
    print("❌ Verification failed: \(error)")
}
```

### 🌐 Vapor Integration

```swift
import Vapor
import FirebaseAuthVapor

// Configure Vapor app
let app = try Application(.detect())

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
```

## 🛠 Advanced Usage

### Custom Claims Handling

```swift
if let role = verifiedToken.claims?["role"] {
    print("👤 User role: \(role)")
}
```

### Cache Configuration

```swift
let keyStore = KeyStore(
    httpClient: httpClient,
    maxKeys: 100,           // Maximum number of cached keys
    validityDuration: 3600, // Cache duration in seconds
    keysURL: "custom-url"   // Optional: custom keys URL
)
```

## ⚠️ Error Handling

FirebaseAuthKit provides clear error cases:

```swift
enum FirebaseAuthError: Error {
    case invalidToken        // ❌ Token format is invalid
    case missingToken       // 🚫 Token not found
    case tokenExpired       // ⏰ Token has expired
    case invalidIssuer      // 🔒 Invalid token issuer
    case invalidAudience    // 👥 Invalid token audience
    case verificationFailed // 💥 Verification process failed
}
```

## 💡 Best Practices

1. 🔄 **Share HTTP Client**: Use a single HTTPClient instance across your application
2. 🎯 **Error Handling**: Properly handle all verification errors
3. 🛑 **Shutdown Management**: Properly shutdown HTTPClient when your application terminates
4. 🔒 **Security**: Always validate tokens on the server side
5. ⚡️ **Performance**: Utilize the built-in caching mechanism for optimal performance

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. 🐛 Report bugs
2. 💡 Suggest new features
3. 📝 Improve documentation
4. 🔧 Submit pull requests

## 📘 Documentation

For detailed documentation, visit our [GitHub Wiki](wiki-link).

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ❓ Support

- 📫 Open an issue for bug reports
- 💭 Start a discussion for feature requests
- 🤔 Check existing issues before opening a new one

## 🌟 Show Your Support

Give a ⭐️ if this project helped you!

## 📊 Stats

![GitHub Stars](https://img.shields.io/github/stars/yourusername/firebase-auth-kit?style=social)
![GitHub Forks](https://img.shields.io/github/forks/yourusername/firebase-auth-kit?style=social)

---

Made with ❤️ by [1amageek](https://x.com/1amageek)
