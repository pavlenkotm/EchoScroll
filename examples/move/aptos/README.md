# Aptos Move Smart Contract Example

## Overview

This directory contains a simple **Coin Flip** game built with **Move** on **Aptos** blockchain. It demonstrates core Move concepts including resources, abilities, and the Aptos framework.

## About Aptos & Move

**Aptos** is a Layer 1 blockchain focused on safety, scalability, and upgradeability. Built by former Meta/Facebook engineers who worked on Diem (Libra).

**Move** is a resource-oriented programming language designed for safe asset management. Key features:

- **Resource Safety**: Assets cannot be copied or dropped (implicitly destroyed)
- **Formal Verification**: Designed for mathematical proof of correctness
- **Flexibility**: Modules and generics for code reuse
- **Security First**: No reentrancy, no overflow, strong type system

## Files

- `sources/coin_flip.move` - Main game contract
- `Move.toml` - Package configuration and dependencies

## Features

The Coin Flip game includes:

- ✅ Initialize player game state
- ✅ Play coin flip with bets
- ✅ Track wins and losses
- ✅ Calculate win rate percentage
- ✅ View functions for game stats
- ✅ Unit tests with expected failures
- ✅ Resource-based game state management

## Contract Functions

### Entry Functions

- **initialize()** - Create game state for player
- **play(bet_amount, guess_heads)** - Play the game with a bet

### View Functions

- **get_stats(player_addr)** - Returns (wins, losses, last_played)
- **get_win_rate(player_addr)** - Returns win percentage

## Setup

### Prerequisites

- Aptos CLI
- Move compiler

### Install Aptos CLI

```bash
curl -fsSL "https://aptos.dev/scripts/install_cli.py" | python3
```

Or with Homebrew (macOS):

```bash
brew install aptos
```

### Initialize Aptos Account

```bash
aptos init
```

## Compilation

Compile the Move module:

```bash
aptos move compile
```

## Testing

Run Move unit tests:

```bash
aptos move test
```

Run specific test:

```bash
aptos move test --filter test_initialize
```

## Deployment

Publish to devnet:

```bash
aptos move publish --named-addresses coin_flip_addr=default
```

Publish to testnet:

```bash
aptos move publish --profile testnet --named-addresses coin_flip_addr=testnet
```

## Usage

Initialize game:

```bash
aptos move run \
  --function-id 'default::coin_flip::initialize'
```

Play the game:

```bash
aptos move run \
  --function-id 'default::coin_flip::play' \
  --args u64:1000000 bool:true
```

Get stats (view function):

```bash
aptos move view \
  --function-id 'default::coin_flip::get_stats' \
  --args address:YOUR_ADDRESS
```

## TypeScript SDK Integration

```typescript
import { AptosClient, AptosAccount, FaucetClient } from "aptos";

const NODE_URL = "https://fullnode.devnet.aptoslabs.com/v1";
const FAUCET_URL = "https://faucet.devnet.aptoslabs.com";

const client = new AptosClient(NODE_URL);
const faucetClient = new FaucetClient(NODE_URL, FAUCET_URL);

// Create account
const account = new AptosAccount();
await faucetClient.fundAccount(account.address(), 100_000_000);

// Initialize game
const payload = {
  type: "entry_function_payload",
  function: `${MODULE_ADDRESS}::coin_flip::initialize`,
  type_arguments: [],
  arguments: [],
};

const txnRequest = await client.generateTransaction(account.address(), payload);
const signedTxn = await client.signTransaction(account, txnRequest);
await client.submitTransaction(signedTxn);

// Play game
const playPayload = {
  type: "entry_function_payload",
  function: `${MODULE_ADDRESS}::coin_flip::play`,
  type_arguments: [],
  arguments: [1000000, true], // bet 1 APT, guess heads
};

// Get stats
const stats = await client.view({
  function: `${MODULE_ADDRESS}::coin_flip::get_stats`,
  type_arguments: [],
  arguments: [account.address().hex()],
});

console.log("Wins:", stats[0]);
console.log("Losses:", stats[1]);
```

## Key Move Concepts

### Resources

Resources are special structs with the `key` ability that represent assets:

```move
struct Game has key {
    // fields
}
```

### Abilities

Move types can have abilities:
- **copy**: Value can be copied
- **drop**: Value can be dropped (destroyed)
- **store**: Value can be stored in global storage
- **key**: Value can be a resource

### Global Storage

Resources are stored at account addresses:

```move
move_to(account, resource); // Store
borrow_global<T>(addr);     // Read
borrow_global_mut<T>(addr); // Write
move_from<T>(addr);         // Remove
```

### Entry Functions

Entry functions can be called directly via transactions:

```move
public entry fun function_name(...) {
    // code
}
```

### View Functions

View functions are read-only and don't modify state:

```move
#[view]
public fun get_data(...): ReturnType {
    // read-only
}
```

## Security Considerations

- This example uses timestamp for randomness (NOT SECURE for production)
- In production, use Aptos randomness API or VRF
- Always validate inputs and check balances
- Use proper error codes
- Test edge cases thoroughly

## Improvements for Production

1. Use secure randomness (Aptos randomness API)
2. Implement actual coin transfers
3. Add house edge and payout logic
4. Implement events for game outcomes
5. Add admin functions
6. Rate limiting and cooldowns

## Resources

- [Aptos Documentation](https://aptos.dev/)
- [Move Book](https://move-language.github.io/move/)
- [Aptos Move Examples](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/move-examples)
- [Aptos TypeScript SDK](https://aptos.dev/sdks/ts-sdk)

## Testing Best Practices

```move
#[test]
public fun test_success_case() {
    // test logic
}

#[test]
#[expected_failure(abort_code = ERROR_CODE)]
public fun test_failure_case() {
    // test error handling
}
```

## License

MIT
