# Go Ethereum RPC Client

## Overview

A Go RPC client for interacting with Ethereum nodes using the go-ethereum library. Demonstrates common blockchain queries and operations.

## Features

- ✅ Connect to any Ethereum RPC endpoint
- ✅ Query chain ID and network info
- ✅ Get block data and transactions
- ✅ Check account balances and nonces
- ✅ Estimate gas for transactions
- ✅ Get current gas prices
- ✅ Transaction receipt lookups

## Setup

```bash
go mod download
```

## Build

```bash
go build -o rpc-client
```

## Run

```bash
./rpc-client
```

## Usage

```go
import "rpc-client"

client, err := NewRPCClient("https://eth.llamarpc.com")
if err != nil {
    log.Fatal(err)
}
defer client.Close()

// Get latest block
blockNum, err := client.GetBlockNumber()

// Get balance
balance, err := client.GetBalance("0x...")

// Get gas price
gasPrice, err := client.GetGasPrice()
```

## Resources

- [go-ethereum Documentation](https://geth.ethereum.org/docs)
- [Ethereum JSON-RPC Spec](https://ethereum.org/en/developers/docs/apis/json-rpc/)

## License

MIT
