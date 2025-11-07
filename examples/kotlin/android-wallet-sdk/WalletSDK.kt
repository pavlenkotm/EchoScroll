package com.web3.walletsdk

import org.web3j.crypto.Credentials
import org.web3j.crypto.Keys
import org.web3j.crypto.WalletUtils
import org.web3j.protocol.Web3j
import org.web3j.protocol.http.HttpService
import org.web3j.utils.Convert
import java.math.BigDecimal
import java.math.BigInteger

/**
 * Android Wallet SDK for Web3
 * Kotlin-based SDK for mobile wallet development
 */
class WalletSDK(private val rpcUrl: String) {

    private val web3j: Web3j = Web3j.build(HttpService(rpcUrl))

    /**
     * Generate a new wallet
     */
    fun generateWallet(): WalletInfo {
        val keyPair = Keys.createEcKeyPair()
        val credentials = Credentials.create(keyPair)

        return WalletInfo(
            address = credentials.address,
            privateKey = credentials.ecKeyPair.privateKey.toString(16),
            publicKey = credentials.ecKeyPair.publicKey.toString(16)
        )
    }

    /**
     * Get balance for an address
     */
    suspend fun getBalance(address: String): BigDecimal {
        val balance = web3j.ethGetBalance(
            address,
            org.web3j.protocol.core.DefaultBlockParameterName.LATEST
        ).sendAsync().get()

        return Convert.fromWei(balance.balance.toString(), Convert.Unit.ETHER)
    }

    /**
     * Get current gas price
     */
    suspend fun getGasPrice(): BigDecimal {
        val gasPrice = web3j.ethGasPrice().sendAsync().get()
        return Convert.fromWei(gasPrice.gasPrice.toString(), Convert.Unit.GWEI)
    }

    /**
     * Get latest block number
     */
    suspend fun getBlockNumber(): BigInteger {
        val blockNumber = web3j.ethBlockNumber().sendAsync().get()
        return blockNumber.blockNumber
    }

    /**
     * Validate Ethereum address
     */
    fun isValidAddress(address: String): Boolean {
        return try {
            WalletUtils.isValidAddress(address)
        } catch (e: Exception) {
            false
        }
    }

    /**
     * Import wallet from private key
     */
    fun importWallet(privateKey: String): WalletInfo {
        val credentials = Credentials.create(privateKey)

        return WalletInfo(
            address = credentials.address,
            privateKey = privateKey,
            publicKey = credentials.ecKeyPair.publicKey.toString(16)
        )
    }

    fun shutdown() {
        web3j.shutdown()
    }
}

/**
 * Wallet information data class
 */
data class WalletInfo(
    val address: String,
    val privateKey: String,
    val publicKey: String
)

/**
 * Example usage
 */
fun main() {
    println("📱 Android Wallet SDK Demo\n")

    val sdk = WalletSDK("https://eth.llamarpc.com")

    try {
        // Generate new wallet
        val wallet = sdk.generateWallet()
        println("🔐 New Wallet Generated:")
        println("   Address: ${wallet.address}")
        println("   Private Key: ${wallet.privateKey}")
        println("\n   ⚠️  KEEP YOUR PRIVATE KEY SAFE!\n")

        // Validate address
        val isValid = sdk.isValidAddress(wallet.address)
        println("Address Validation: ${if (isValid) "✓ Valid" else "✗ Invalid"}\n")

        // Check Vitalik's balance
        kotlinx.coroutines.runBlocking {
            val vitalikAddress = "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"
            val balance = sdk.getBalance(vitalikAddress)
            val gasPrice = sdk.getGasPrice()
            val blockNumber = sdk.getBlockNumber()

            println("💰 Vitalik's Balance: $balance ETH")
            println("⛽ Current Gas Price: $gasPrice gwei")
            println("📦 Latest Block: $blockNumber")
        }

        println("\n✓ SDK Demo Complete!")

    } catch (e: Exception) {
        println("✗ Error: ${e.message}")
        e.printStackTrace()
    } finally {
        sdk.shutdown()
    }
}
