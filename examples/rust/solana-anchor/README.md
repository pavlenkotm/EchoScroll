# Solana Anchor Program Example

## Overview

This directory contains a simple **counter program** built with **Anchor**, the most popular framework for Solana development. It demonstrates core Solana concepts including accounts, instructions, and program-derived addresses (PDAs).

## About Solana & Anchor

**Solana** is a high-performance blockchain designed for decentralized applications and crypto-currencies. It uses Proof of History (PoH) consensus and can process 65,000+ transactions per second.

**Anchor** is a framework for Solana that provides:
- High-level abstractions for common patterns
- Automated security checks
- IDL (Interface Description Language) generation
- TypeScript client generation
- Testing utilities

## Files

- `lib.rs` - Main Anchor program with counter logic
- `Cargo.toml` - Rust package configuration
- `Anchor.toml` - Anchor project configuration

## Features

The Simple Counter program includes:

- ✅ Initialize counter account
- ✅ Increment counter value
- ✅ Decrement counter value (with underflow protection)
- ✅ Reset counter to zero
- ✅ Authority validation (only owner can modify)
- ✅ Checked arithmetic to prevent overflow/underflow

## Program Structure

### Instructions

1. **initialize** - Creates a new counter account
2. **increment** - Adds 1 to the counter
3. **decrement** - Subtracts 1 from the counter (fails if count = 0)
4. **reset** - Sets counter back to 0

### Accounts

- **Counter** - Stores the count value and authority pubkey

### Security Features

- Authority validation with `has_one` constraint
- Overflow/underflow protection with checked arithmetic
- Custom error codes for better error handling

## Setup

### Prerequisites

- Rust 1.70+
- Solana CLI 1.16+
- Anchor CLI 0.29+
- Node.js 16+

### Install Dependencies

```bash
# Install Solana
sh -c "$(curl -sSfL https://release.solana.com/v1.17.0/install)"

# Install Anchor
cargo install --git https://github.com/coral-xyz/anchor avm --locked --force
avm install latest
avm use latest
```

## Build

```bash
anchor build
```

## Test

```bash
anchor test
```

## Deploy

Deploy to devnet:

```bash
anchor deploy --provider.cluster devnet
```

Deploy to mainnet:

```bash
anchor deploy --provider.cluster mainnet
```

## Client Usage

TypeScript client example:

```typescript
import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import { SimpleCounter } from "../target/types/simple_counter";

const provider = anchor.AnchorProvider.env();
anchor.setProvider(provider);

const program = anchor.workspace.SimpleCounter as Program<SimpleCounter>;

// Create counter account
const counter = anchor.web3.Keypair.generate();

await program.methods
  .initialize()
  .accounts({
    counter: counter.publicKey,
    user: provider.wallet.publicKey,
    systemProgram: anchor.web3.SystemProgram.programId,
  })
  .signers([counter])
  .rpc();

// Increment
await program.methods
  .increment()
  .accounts({
    counter: counter.publicKey,
    authority: provider.wallet.publicKey,
  })
  .rpc();

// Fetch counter value
const counterAccount = await program.account.counter.fetch(counter.publicKey);
console.log("Count:", counterAccount.count.toString());
```

## Testing Example

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_initialize() {
        // Test initialization
    }

    #[test]
    fn test_increment() {
        // Test increment logic
    }

    #[test]
    #[should_panic(expected = "CounterUnderflow")]
    fn test_underflow_protection() {
        // Test that decrement fails when count is 0
    }
}
```

## Key Concepts

### Accounts

Solana programs are stateless. All state is stored in accounts owned by the program.

### PDAs (Program Derived Addresses)

PDAs are addresses derived deterministically from seeds, allowing programs to "sign" for accounts.

### Cross-Program Invocation (CPI)

Anchor makes it easy to call other programs using the CPI pattern.

## Resources

- [Solana Documentation](https://docs.solana.com/)
- [Anchor Book](https://book.anchor-lang.com/)
- [Solana Cookbook](https://solanacookbook.com/)
- [Anchor Examples](https://github.com/coral-xyz/anchor/tree/master/examples)

## Security Best Practices

- Always validate account ownership
- Use checked arithmetic
- Implement proper access control
- Test edge cases thoroughly
- Audit before mainnet deployment

## License

MIT
