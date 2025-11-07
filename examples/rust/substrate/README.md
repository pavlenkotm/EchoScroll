# Substrate Pallet Example

## Overview

This directory contains a simple **Rewards Pallet** built for **Substrate**, the blockchain framework powering Polkadot, Kusama, and hundreds of other chains.

## About Substrate

**Substrate** is a modular framework for building custom blockchains. It powers:

- **Polkadot** - Heterogeneous multi-chain network
- **Kusama** - Canary network for Polkadot
- **Hundreds of parachains** - Custom application-specific blockchains

Key features:
- **Modular Architecture**: Compose runtime from pallets (modules)
- **Forkless Upgrades**: Update chain logic without hard forks
- **Flexible Consensus**: Choose from PoW, PoS, PoA, etc.
- **Interoperability**: Native cross-chain message passing (XCM)

## Files

- `lib.rs` - Rewards pallet implementation
- `Cargo.toml` - Dependencies and feature flags

## Features

The Rewards Pallet includes:

- ✅ Grant rewards to users (root only)
- ✅ Claim accumulated rewards
- ✅ Track total rewards distributed
- ✅ Maximum reward limit validation
- ✅ Event emissions for all actions
- ✅ Comprehensive error handling

## Pallet Structure

### Storage

- **Rewards** - Maps AccountId to reward balance
- **TotalRewards** - Tracks total rewards distributed

### Extrinsics (Dispatchable Functions)

1. **grant_reward** - Grant rewards to a user (root only)
2. **claim_reward** - Claim your accumulated rewards
3. **get_reward_balance** - Query reward balance

### Events

- **RewardGranted** - Emitted when rewards are granted
- **RewardClaimed** - Emitted when rewards are claimed

### Errors

- **RewardTooLarge** - Reward exceeds maximum allowed
- **NoRewardsAvailable** - No rewards to claim
- **Overflow** - Arithmetic overflow

## Setup

### Prerequisites

- Rust 1.70+
- Substrate dependencies

### Install Substrate Dependencies

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Add wasm target
rustup target add wasm32-unknown-unknown

# Install Substrate node template (optional)
git clone https://github.com/substrate-developer-hub/substrate-node-template
```

## Build

Build the pallet:

```bash
cargo build --release
```

Build for WASM:

```bash
cargo build --release --target wasm32-unknown-unknown
```

## Testing

Run unit tests:

```bash
cargo test
```

Run tests with output:

```bash
cargo test -- --nocapture
```

## Integration

Add to your runtime's `Cargo.toml`:

```toml
[dependencies]
pallet-rewards = { path = "../pallets/rewards", default-features = false }

[features]
std = [
    "pallet-rewards/std",
]
```

Configure in your runtime:

```rust
impl pallet_rewards::Config for Runtime {
    type RuntimeEvent = RuntimeEvent;
    type MaxReward = ConstU32<1000>;
}

construct_runtime!(
    pub enum Runtime where
        Block = Block,
        NodeBlock = opaque::Block,
        UncheckedExtrinsic = UncheckedExtrinsic
    {
        System: frame_system,
        Rewards: pallet_rewards,
        // ... other pallets
    }
);
```

## Usage

Grant rewards (requires sudo/root):

```bash
# Using polkadot-js apps
rewards.grantReward(beneficiary, amount)
```

Claim rewards:

```bash
# Any signed user can claim their rewards
rewards.claimReward()
```

Query reward balance:

```bash
# Query storage
rewards.rewards(accountId)
```

## JavaScript Integration

Using Polkadot.js API:

```javascript
import { ApiPromise, WsProvider } from '@polkadot/api';

const wsProvider = new WsProvider('ws://127.0.0.1:9944');
const api = await ApiPromise.create({ provider: wsProvider });

// Grant rewards (requires sudo)
const tx = api.tx.rewards.grantReward(beneficiaryAccount, 100);
await tx.signAndSend(sudoAccount);

// Claim rewards
const claimTx = api.tx.rewards.claimReward();
await claimTx.signAndSend(userAccount);

// Query balance
const balance = await api.query.rewards.rewards(accountId);
console.log(`Rewards: ${balance.toString()}`);

// Subscribe to events
api.query.system.events((events) => {
  events.forEach((record) => {
    const { event } = record;
    if (event.section === 'rewards') {
      console.log(`Rewards event: ${event.method}`, event.data.toJSON());
    }
  });
});
```

## Key Substrate Concepts

### Pallets

Pallets are modular components that encapsulate specific blockchain logic (like this rewards system).

### Runtime

The runtime is the state transition function of your blockchain, composed of multiple pallets.

### Extrinsics

User-submitted operations that can modify chain state (like transactions).

### Storage

On-chain storage using efficient key-value databases. Use appropriate storage types:
- **StorageValue** - Single value
- **StorageMap** - Key-value pairs
- **StorageDoubleMap** - Two-key lookups

### Events

Emit events to notify external observers of important state changes.

## Advanced Features

### Benchmarking

Add benchmarks for accurate weight calculations:

```rust
#[cfg(feature = "runtime-benchmarks")]
mod benchmarking;
```

### Migration

Handle storage migrations:

```rust
pub mod migrations {
    use super::*;

    pub fn migrate_to_v2<T: Config>() -> Weight {
        // Migration logic
    }
}
```

## Resources

- [Substrate Documentation](https://docs.substrate.io/)
- [Substrate Tutorials](https://docs.substrate.io/tutorials/)
- [Polkadot Wiki](https://wiki.polkadot.network/)
- [Substrate Stack Exchange](https://substrate.stackexchange.com/)
- [Awesome Substrate](https://github.com/substrate-developer-hub/awesome-substrate)

## Best Practices

- Use `ensure!` for validation
- Emit events for important state changes
- Use `saturating_*` or `checked_*` arithmetic
- Document all public functions
- Write comprehensive tests
- Benchmark extrinsics accurately

## License

MIT
