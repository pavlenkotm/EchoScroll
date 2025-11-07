# AssemblyScript WASM Contract

## Overview

AssemblyScript smart contract compiled to WebAssembly for NEAR Protocol. Demonstrates WASM-based blockchain development.

## About AssemblyScript

**AssemblyScript** is a TypeScript-like language that compiles to WebAssembly. Perfect for:
- NEAR Protocol smart contracts
- High-performance WASM modules
- Developers familiar with TypeScript
- Strict typing with WebAssembly efficiency

## Features

- ✅ Add messages to guestbook
- ✅ Query messages by ID or author
- ✅ Get recent messages with pagination
- ✅ Check posting history
- ✅ Persistent storage with NEAR SDK
- ✅ Type-safe contract methods

## Build

```bash
npm install
npm run build
```

Output: `build/release.wasm`

## Test

```bash
npm test
```

## Deploy

Deploy to NEAR testnet:

```bash
near deploy --accountId YOUR_ACCOUNT.testnet --wasmFile build/release.wasm
```

## Usage

Add a message:

```bash
near call YOUR_ACCOUNT.testnet addMessage '{"text": "Hello NEAR!"}' --accountId YOUR_ACCOUNT.testnet
```

Get recent messages:

```bash
near view YOUR_ACCOUNT.testnet getRecentMessages '{"limit": 10}'
```

Get message by ID:

```bash
near view YOUR_ACCOUNT.testnet getMessage '{"id": 0}'
```

Get messages by author:

```bash
near view YOUR_ACCOUNT.testnet getMessagesByAuthor '{"author": "alice.testnet"}'
```

## Contract Methods

### Change Methods (require transaction)

- **addMessage(text: string)** - Add a new message

### View Methods (read-only)

- **getMessage(id: u64)** - Get message by ID
- **getMessageCount()** - Get total message count
- **getRecentMessages(limit: u64)** - Get last N messages
- **getMessagesByAuthor(author: string)** - Get all messages by author
- **hasPosted(author: string)** - Check if user has posted
- **getInfo()** - Get contract information

## JavaScript Integration

```javascript
import { connect, Contract } from 'near-api-js';

const contract = new Contract(account, 'guestbook.testnet', {
  viewMethods: ['getMessage', 'getRecentMessages'],
  changeMethods: ['addMessage'],
});

// Add message
await contract.addMessage({ text: 'Hello!' });

// Get messages
const messages = await contract.getRecentMessages({ limit: 10 });
```

## Key Concepts

### @nearBindgen

Decorator for classes that need to be serialized:

```typescript
@nearBindgen
export class Message {
  // class definition
}
```

### PersistentMap

On-chain key-value storage:

```typescript
const messages = new PersistentMap<u64, Message>("m");
messages.set(key, value);
const value = messages.get(key);
```

### Context

Transaction context information:

```typescript
context.sender      // Caller's account ID
context.blockTimestamp  // Current block timestamp
context.networkId   // Network ID (mainnet/testnet)
```

## Advantages

- Type safety with TypeScript-like syntax
- Compiles to efficient WebAssembly
- Smaller contract size than Rust
- Familiar for web developers
- Near-native performance

## Resources

- [AssemblyScript Documentation](https://www.assemblyscript.org/)
- [NEAR AssemblyScript SDK](https://github.com/near/near-sdk-as)
- [NEAR Examples](https://examples.near.org/)

## Testing

Create `__tests__/index.unit.spec.ts`:

```typescript
import { addMessage, getMessage } from '../assembly';

describe("Guestbook", () => {
  it("should add and retrieve message", () => {
    const id = addMessage("Test message");
    const message = getMessage(id);

    expect(message).not.toBeNull();
    expect(message!.text).toBe("Test message");
  });
});
```

## License

MIT
