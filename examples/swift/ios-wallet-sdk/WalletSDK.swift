import Foundation
import Web3
import BigInt

/// iOS Wallet SDK for Web3
/// Swift-based SDK for iOS wallet development
@available(iOS 13.0, *)
public class WalletSDK {

    private let rpcURL: String
    private var web3: Web3?

    public init(rpcURL: String) {
        self.rpcURL = rpcURL
        self.web3 = Web3(rpcURL: rpcURL)
    }

    /// Generate a new Ethereum wallet
    public func generateWallet() throws -> WalletInfo {
        let account = try EthereumAccount.create()

        return WalletInfo(
            address: account.address.hex(eip55: true),
            privateKey: account.privateKey.hex,
            publicKey: account.publicKey.hex
        )
    }

    /// Get balance for an address
    public func getBalance(address: String) async throws -> Decimal {
        guard let web3 = web3 else {
            throw WalletError.notInitialized
        }

        let ethAddress = try EthereumAddress(hex: address, eip55: true)
        let balance = try await web3.eth.getBalance(address: ethAddress, block: .latest)

        // Convert Wei to Ether
        let balanceDecimal = Decimal(string: balance.description) ?? 0
        return balanceDecimal / Decimal(sign: .plus, exponent: 18, significand: 1)
    }

    /// Get current gas price in Gwei
    public func getGasPrice() async throws -> Decimal {
        guard let web3 = web3 else {
            throw WalletError.notInitialized
        }

        let gasPrice = try await web3.eth.gasPrice()
        let gasPriceDecimal = Decimal(string: gasPrice.description) ?? 0

        // Convert Wei to Gwei
        return gasPriceDecimal / Decimal(sign: .plus, exponent: 9, significand: 1)
    }

    /// Get latest block number
    public func getBlockNumber() async throws -> BigUInt {
        guard let web3 = web3 else {
            throw WalletError.notInitialized
        }

        return try await web3.eth.blockNumber()
    }

    /// Validate Ethereum address
    public func isValidAddress(_ address: String) -> Bool {
        return (try? EthereumAddress(hex: address, eip55: false)) != nil
    }

    /// Import wallet from private key
    public func importWallet(privateKey: String) throws -> WalletInfo {
        let account = try EthereumAccount(keyStorage: EthereumKeyLocalStorage())

        return WalletInfo(
            address: account.address.hex(eip55: true),
            privateKey: privateKey,
            publicKey: account.publicKey.hex
        )
    }
}

/// Wallet information model
public struct WalletInfo: Codable {
    public let address: String
    public let privateKey: String
    public let publicKey: String
}

/// Wallet SDK errors
public enum WalletError: Error {
    case notInitialized
    case invalidAddress
    case networkError
    case invalidPrivateKey

    public var localizedDescription: String {
        switch self {
        case .notInitialized:
            return "SDK not properly initialized"
        case .invalidAddress:
            return "Invalid Ethereum address"
        case .networkError:
            return "Network connection error"
        case .invalidPrivateKey:
            return "Invalid private key format"
        }
    }
}

/// Example usage
@available(iOS 13.0, *)
func main() async {
    print("📱 iOS Wallet SDK Demo\n")

    let sdk = WalletSDK(rpcURL: "https://eth.llamarpc.com")

    do {
        // Generate new wallet
        let wallet = try sdk.generateWallet()
        print("🔐 New Wallet Generated:")
        print("   Address: \(wallet.address)")
        print("   Private Key: \(wallet.privateKey)")
        print("\n   ⚠️  KEEP YOUR PRIVATE KEY SAFE!\n")

        // Validate address
        let isValid = sdk.isValidAddress(wallet.address)
        print("Address Validation: \(isValid ? "✓ Valid" : "✗ Invalid")\n")

        // Check Vitalik's balance
        let vitalikAddress = "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"
        let balance = try await sdk.getBalance(address: vitalikAddress)
        let gasPrice = try await sdk.getGasPrice()
        let blockNumber = try await sdk.getBlockNumber()

        print("💰 Vitalik's Balance: \(balance) ETH")
        print("⛽ Current Gas Price: \(gasPrice) gwei")
        print("📦 Latest Block: \(blockNumber)")

        print("\n✓ SDK Demo Complete!")

    } catch {
        print("✗ Error: \(error.localizedDescription)")
    }
}

// Run example (uncomment for testing)
// Task {
//     await main()
// }
