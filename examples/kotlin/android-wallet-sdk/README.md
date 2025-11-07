# Kotlin Android Wallet SDK

## Overview

Kotlin-based SDK for building Web3 wallets on Android. Demonstrates modern Kotlin patterns with coroutines and Web3j.

## Features

- ✅ Wallet generation and import
- ✅ Balance queries with coroutines
- ✅ Gas price monitoring
- ✅ Address validation
- ✅ Async operations support
- ✅ Type-safe with Kotlin data classes

## Build

```bash
./gradlew build
```

## Run

```bash
./gradlew run
```

## Usage in Android

```kotlin
class MainActivity : AppCompatActivity() {
    private lateinit var walletSDK: WalletSDK

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        walletSDK = WalletSDK("https://eth.llamarpc.com")

        // Generate wallet
        lifecycleScope.launch {
            val wallet = walletSDK.generateWallet()
            val balance = walletSDK.getBalance(wallet.address)

            withContext(Dispatchers.Main) {
                // Update UI
            }
        }
    }
}
```

## Integration

Add to `build.gradle.kts`:

```kotlin
dependencies {
    implementation("org.web3j:core:4.10.3")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
}
```

## Resources

- [Web3j Documentation](https://docs.web3j.io/)
- [Kotlin Coroutines](https://kotlinlang.org/docs/coroutines-overview.html)

## License

MIT
