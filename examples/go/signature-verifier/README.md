# Go Ethereum Signature Verifier

## Overview

A Go implementation of Ethereum signature verification using go-ethereum library. Demonstrates ECDSA signature creation, verification, and address recovery.

## Features

- ✅ Generate Ethereum key pairs
- ✅ Sign messages with private keys
- ✅ Verify signatures against addresses
- ✅ Recover signer address from signature
- ✅ Ethereum signed message hashing
- ✅ Full signature validation

## Setup

```bash
go mod download
```

## Build

```bash
go build -o signature-verifier
```

## Run

```bash
./signature-verifier
```

Or directly:

```bash
go run main.go
```

## Usage as Library

```go
import "signature-verifier"

verifier := NewSignatureVerifier()

// Verify signature
valid, err := verifier.VerifySignature(
    "Hello, Ethereum!",
    "0x...", // signature
    "0x...", // expected address
)

// Recover address
address, err := verifier.RecoverAddress(message, signature)
```

## Key Functions

- **GenerateKeyPair()** - Create new Ethereum wallet
- **SignMessage()** - Sign message with private key
- **VerifySignature()** - Verify signature matches address
- **RecoverAddress()** - Extract signer address from signature
- **HashMessage()** - Hash with Ethereum signed message prefix

## Resources

- [go-ethereum Documentation](https://geth.ethereum.org/docs)
- [Ethereum Signature Spec](https://eips.ethereum.org/EIPS/eip-191)

## License

MIT
