# Java Web3j Example

## Overview

Java application demonstrating Web3j library for Ethereum blockchain interaction.

## Features

- ✅ Connect to Ethereum RPC
- ✅ Query block numbers and balances
- ✅ Get gas prices
- ✅ Generate wallets
- ✅ Wallet management

## Build

```bash
mvn clean package
```

## Run

```bash
mvn exec:java
```

Or with Java directly:

```bash
java -cp target/web3j-example-1.0.0.jar:target/dependency/* com.web3.example.Web3Example
```

## Usage

```java
Web3Example client = new Web3Example("https://eth.llamarpc.com");

// Get block number
BigInteger blockNumber = client.getBlockNumber();

// Get balance
BigDecimal balance = client.getBalance("0x...");

// Generate wallet
Credentials credentials = Web3Example.generateWallet();
```

## Resources

- [Web3j Documentation](https://docs.web3j.io/)
- [Web3j GitHub](https://github.com/web3j/web3j)

## License

MIT
