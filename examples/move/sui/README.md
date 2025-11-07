# Sui Move Smart Contract Example

## Overview

This directory contains a simple **NFT Marketplace** built with **Move** on **Sui** blockchain. It demonstrates Sui's object-centric model, shared objects, and transfer mechanisms.

## About Sui & Move

**Sui** is a Layer 1 blockchain designed for high throughput and low latency. Built by Mysten Labs (also former Meta engineers).

Sui's unique features:
- **Object-Centric Storage**: Everything is an object with a unique ID
- **Parallel Execution**: Independent transactions execute in parallel
- **Owned vs Shared Objects**: Flexible ownership models
- **No Global Storage**: Objects owned by addresses or shared
- **Instant Finality**: Fast transaction confirmation

## Files

- `sources/nft_marketplace.move` - NFT marketplace implementation
- `Move.toml` - Package configuration

## Features

The NFT Marketplace includes:

- ✅ Mint custom NFTs with metadata
- ✅ List NFTs for sale (escrow mechanism)
- ✅ Buy NFTs with SUI tokens
- ✅ Delist (cancel) listings
- ✅ Event emissions for all actions
- ✅ Seller verification for delisting
- ✅ Payment validation

## Object Structure

### NFT

- **name**: NFT name
- **description**: NFT description
- **url**: Image/media URL

### Listing

- **nft_id**: ID of the listed NFT
- **seller**: Seller address
- **price**: Sale price in SUI

## Contract Functions

### Entry Functions

- **mint_nft(name, description, url)** - Create a new NFT
- **list_nft(nft, price)** - List NFT for sale
- **buy_nft(listing, nft, payment)** - Purchase NFT
- **delist_nft(listing, nft)** - Cancel listing (seller only)

### View Functions

- **get_nft_name(nft)** - Get NFT name
- **get_nft_description(nft)** - Get NFT description
- **get_nft_url(nft)** - Get NFT URL
- **get_listing_price(listing)** - Get listing price
- **get_listing_seller(listing)** - Get seller address

## Setup

### Prerequisites

- Sui CLI
- Rust (for Sui CLI)

### Install Sui CLI

```bash
cargo install --locked --git https://github.com/MystenLabs/sui.git --branch mainnet sui
```

Or download binary from [Sui releases](https://github.com/MystenLabs/sui/releases).

### Initialize Sui Environment

```bash
sui client
```

## Build

Build the Move package:

```bash
sui move build
```

## Testing

Run Move unit tests:

```bash
sui move test
```

## Deployment

Publish to devnet:

```bash
sui client publish --gas-budget 100000000
```

Publish to testnet:

```bash
sui client publish --gas-budget 100000000 --network testnet
```

## Usage

Mint an NFT:

```bash
sui client call \
  --package PACKAGE_ID \
  --module simple_marketplace \
  --function mint_nft \
  --args "My NFT" "A cool NFT" "https://example.com/nft.png" \
  --gas-budget 10000000
```

List NFT for sale:

```bash
sui client call \
  --package PACKAGE_ID \
  --module simple_marketplace \
  --function list_nft \
  --args NFT_OBJECT_ID 1000000000 \
  --gas-budget 10000000
```

Buy NFT:

```bash
sui client call \
  --package PACKAGE_ID \
  --module simple_marketplace \
  --function buy_nft \
  --args LISTING_ID NFT_OBJECT_ID COIN_OBJECT_ID \
  --gas-budget 10000000
```

## TypeScript SDK Integration

```typescript
import { JsonRpcProvider, RawSigner, TransactionBlock } from '@mysten/sui.js';

const provider = new JsonRpcProvider();
const signer = new RawSigner(keypair, provider);

// Mint NFT
const tx = new TransactionBlock();
tx.moveCall({
  target: `${packageId}::simple_marketplace::mint_nft`,
  arguments: [
    tx.pure("My NFT"),
    tx.pure("Description"),
    tx.pure("https://example.com/image.png"),
  ],
});

const result = await signer.signAndExecuteTransactionBlock({
  transactionBlock: tx,
  options: {
    showEffects: true,
    showObjectChanges: true,
  },
});

console.log("NFT Minted:", result);

// List NFT
const listTx = new TransactionBlock();
listTx.moveCall({
  target: `${packageId}::simple_marketplace::list_nft`,
  arguments: [
    listTx.object(nftId),
    listTx.pure(1000000000), // price in MIST (1 SUI)
  ],
});

await signer.signAndExecuteTransactionBlock({ transactionBlock: listTx });

// Buy NFT
const buyTx = new TransactionBlock();
const [coin] = buyTx.splitCoins(buyTx.gas, [buyTx.pure(1000000000)]);

buyTx.moveCall({
  target: `${packageId}::simple_marketplace::buy_nft`,
  arguments: [
    buyTx.object(listingId),
    buyTx.object(nftId),
    coin,
  ],
});

await signer.signAndExecuteTransactionBlock({ transactionBlock: buyTx });
```

## Key Sui Concepts

### Objects

Everything in Sui is an object:

```move
struct MyObject has key {
    id: UID,
    // fields
}
```

### Object Ownership

Objects can be:
1. **Owned** - Owned by an address (fast, parallel execution)
2. **Shared** - Accessible by anyone (requires consensus)
3. **Immutable** - Read-only, never changes

### Transfer Patterns

```move
// Transfer to address
transfer::public_transfer(obj, recipient);

// Make shared
transfer::share_object(obj);

// Make immutable
transfer::freeze_object(obj);
```

### Abilities

- **key**: Can be an object (has UID)
- **store**: Can be stored inside other objects
- **copy**: Can be copied
- **drop**: Can be discarded

### Entry Functions

Can be called directly from transactions:

```move
public entry fun my_function(...) {
    // code
}
```

### Events

Emit events for indexing:

```move
event::emit(MyEvent { data });
```

## Architecture

1. **Mint**: User creates NFT, transferred to owner
2. **List**: NFT transferred to listing (escrow), listing shared
3. **Buy**: Payment verified, NFT to buyer, payment to seller
4. **Delist**: NFT returned to seller, listing destroyed

## Security Features

- Payment amount validation
- Seller verification for delisting
- Object capability model (only owner can transfer)
- Type safety with Move's strong typing

## Improvements for Production

1. Add royalty system
2. Implement offers/bidding
3. Add marketplace fees
4. Support multiple currencies
5. Add NFT collections
6. Implement auctions
7. Add metadata standards

## Resources

- [Sui Documentation](https://docs.sui.io/)
- [Sui Move by Example](https://examples.sui.io/)
- [Sui TypeScript SDK](https://sui-typescript-docs.vercel.app/)
- [Sui Examples](https://github.com/MystenLabs/sui/tree/main/sui_programmability/examples)

## Events

All marketplace actions emit events:
- **NFTMinted** - When NFT is created
- **NFTListed** - When NFT is listed for sale
- **NFTSold** - When NFT is purchased

Query events:

```typescript
const events = await provider.queryEvents({
  query: { MoveModule: { package: packageId, module: 'simple_marketplace' } }
});
```

## License

MIT
