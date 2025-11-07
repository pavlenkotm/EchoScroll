# NEAR Protocol Smart Contract Example

## Overview

This directory contains a **GuestBook** smart contract built for **NEAR Protocol** using Rust and the NEAR SDK. It demonstrates key NEAR concepts including accounts, storage, and cross-contract calls.

## About NEAR Protocol

**NEAR** is a user-friendly, carbon-neutral blockchain built to enable the creation and distribution of decentralized applications. Key features:

- **Fast & Scalable**: Sharded architecture for high throughput
- **Low Fees**: Transaction costs under $0.01
- **Developer Friendly**: Rust and AssemblyScript SDKs
- **Human-Readable Accounts**: Use names like `alice.near` instead of hex addresses
- **Progressive Security**: Contracts can be upgraded

## Files

- `lib.rs` - Main NEAR smart contract implementation
- `Cargo.toml` - Rust package and build configuration

## Features

The GuestBook contract includes:

- ✅ Add messages with optional NEAR token donations
- ✅ Retrieve messages by ID or author
- ✅ Get recent messages (pagination support)
- ✅ Tip message authors directly
- ✅ Track total donations
- ✅ Comprehensive unit tests
- ✅ Message validation (length, empty checks)

## Contract Methods

### Write Methods

- **add_message(text: String)** - Add a new message (payable)
- **tip_message(message_id: u64)** - Send NEAR tokens to message author (payable)

### View Methods

- **get_message(id: u64)** - Get a specific message
- **get_message_count()** - Get total number of messages
- **get_recent_messages(limit: u64)** - Get last N messages
- **get_messages_by_author(author: AccountId)** - Get all messages by an author
- **get_total_donations()** - Get total NEAR donated across all messages

## Setup

### Prerequisites

- Rust 1.70+
- NEAR CLI
- Node.js 16+

### Install NEAR CLI

```bash
npm install -g near-cli
```

### Configure NEAR CLI

```bash
near login
```

## Build

Build the contract for deployment:

```bash
cargo build --target wasm32-unknown-unknown --release
```

Or use the NEAR build script:

```bash
./build.sh
```

## Test

Run unit tests:

```bash
cargo test
```

## Deploy

Deploy to NEAR testnet:

```bash
near deploy --accountId YOUR_ACCOUNT.testnet --wasmFile target/wasm32-unknown-unknown/release/near_guestbook.wasm
```

Initialize the contract:

```bash
near call YOUR_ACCOUNT.testnet new '{}' --accountId YOUR_ACCOUNT.testnet
```

## Usage

Add a message:

```bash
near call YOUR_ACCOUNT.testnet add_message '{"text": "Hello NEAR!"}' --accountId YOUR_ACCOUNT.testnet
```

Add a message with donation (1 NEAR):

```bash
near call YOUR_ACCOUNT.testnet add_message '{"text": "Love this project!"}' --accountId YOUR_ACCOUNT.testnet --amount 1
```

Get recent messages:

```bash
near view YOUR_ACCOUNT.testnet get_recent_messages '{"limit": 10}'
```

Get message by ID:

```bash
near view YOUR_ACCOUNT.testnet get_message '{"id": 0}'
```

Tip a message author (0.5 NEAR):

```bash
near call YOUR_ACCOUNT.testnet tip_message '{"message_id": 0}' --accountId YOUR_ACCOUNT.testnet --amount 0.5
```

## JavaScript/TypeScript Integration

```javascript
import { connect, keyStores, utils } from 'near-api-js';

const nearConfig = {
  networkId: 'testnet',
  keyStore: new keyStores.BrowserLocalStorageKeyStore(),
  nodeUrl: 'https://rpc.testnet.near.org',
  walletUrl: 'https://wallet.testnet.near.org',
};

const near = await connect(nearConfig);
const account = await near.account('user.testnet');
const contract = new Contract(account, 'guestbook.testnet', {
  viewMethods: ['get_message', 'get_recent_messages'],
  changeMethods: ['add_message', 'tip_message'],
});

// Add message with 1 NEAR donation
await contract.add_message(
  { text: 'Hello from JS!' },
  '300000000000000', // gas
  utils.format.parseNearAmount('1') // 1 NEAR
);

// Get recent messages
const messages = await contract.get_recent_messages({ limit: 10 });
console.log(messages);
```

## Key NEAR Concepts

### Storage Staking

NEAR requires contracts to stake NEAR tokens for storage. The amount is calculated based on data size.

### Gas

All contract calls consume gas. Complex operations require more gas. Default: 30 TGas.

### Accounts

NEAR uses human-readable account IDs (e.g., `alice.near`, `contract.testnet`).

### Cross-Contract Calls

NEAR supports asynchronous cross-contract calls using Promises.

## Testing

Run tests with:

```bash
cargo test -- --nocapture
```

Integration test example:

```bash
cd integration-tests
npm install
npm test
```

## Security Considerations

- Validate all inputs
- Use `#[payable]` only when necessary
- Check attached deposits
- Implement access control for sensitive operations
- Audit before mainnet deployment

## Resources

- [NEAR Documentation](https://docs.near.org/)
- [NEAR SDK Rust](https://www.near-sdk.io/)
- [NEAR Examples](https://github.com/near-examples)
- [NEAR University](https://www.near.university/)

## Gas Optimization

- Use `LookupMap` for large datasets (O(1) lookups)
- Avoid unnecessary iterations
- Batch operations when possible
- Return early from functions

## License

MIT
