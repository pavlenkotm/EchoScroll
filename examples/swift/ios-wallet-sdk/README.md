# Swift iOS Wallet SDK

## Overview

Swift-based SDK for building Web3 wallets on iOS. Demonstrates modern Swift with async/await and SwiftUI integration.

## Features

- ✅ Wallet generation and import
- ✅ Async/await balance queries
- ✅ Gas price monitoring
- ✅ Address validation
- ✅ SwiftUI compatible
- ✅ Type-safe with Swift structs

## Build

```bash
swift build
```

## Run Tests

```bash
swift test
```

## Usage in iOS App

```swift
import SwiftUI
import WalletSDK

struct ContentView: View {
    @State private var balance = "0"
    private let sdk = WalletSDK(rpcURL: "https://eth.llamarpc.com")

    var body: some View {
        VStack {
            Text("Balance: \(balance) ETH")
                .font(.title)

            Button("Refresh Balance") {
                Task {
                    let bal = try await sdk.getBalance(address: "0x...")
                    balance = "\(bal)"
                }
            }
        }
    }
}
```

## Integration

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/argentlabs/web3.swift", from: "1.6.0")
]
```

Or use CocoaPods:

```ruby
pod 'web3.swift', '~> 1.6'
```

## Example App Flow

```swift
class WalletManager: ObservableObject {
    @Published var wallet: WalletInfo?
    @Published var balance: Decimal = 0

    private let sdk = WalletSDK(rpcURL: "https://eth.llamarpc.com")

    func createWallet() async throws {
        wallet = try sdk.generateWallet()
    }

    func refreshBalance() async throws {
        guard let address = wallet?.address else { return }
        balance = try await sdk.getBalance(address: address)
    }
}
```

## Resources

- [web3.swift Documentation](https://github.com/argentlabs/web3.swift)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)

## License

MIT
