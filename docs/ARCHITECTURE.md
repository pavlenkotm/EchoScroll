# Architecture Overview

## System Design

EchoScroll is designed as a multi-language Web3 development showcase with a functional decentralized blog platform at its core.

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Frontend (Next.js)                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  React UI    │  │  Web3 Wallet │  │  IPFS Client │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└────────────┬────────────────┬────────────────┬─────────┘
             │                │                │
             ▼                ▼                ▼
    ┌────────────┐   ┌────────────┐   ┌────────────┐
    │  Ethereum  │   │  RainbowKit│   │    IPFS    │
    │    RPC     │   │   (Wagmi)  │   │  (Infura)  │
    └────────────┘   └────────────┘   └────────────┘
             │                │                │
             ▼                ▼                ▼
    ┌────────────────────────────────────────────┐
    │        Smart Contracts (Solidity)          │
    │  ┌──────────────────────────────────────┐  │
    │  │       EchoScroll.sol (Main)          │  │
    │  └──────────────────────────────────────┘  │
    └────────────────────────────────────────────┘
                         │
                         ▼
              ┌──────────────────┐
              │  zkSync Era L2   │
              └──────────────────┘
```

## Core Components

### 1. Smart Contract Layer

**EchoScroll.sol**
- Manages scroll (post) lifecycle
- Implements spell-based deletion
- Stores IPFS hash references
- Emits events for indexing

**Key Features:**
- Keccak256 password hashing
- Access control (only author can delete)
- Event emissions for frontend updates
- Gas-optimized storage patterns

### 2. Frontend Layer

**Next.js App Router**
- Server-side rendering
- Client-side state management
- Web3 wallet integration
- Markdown editor

**Components:**
- ScrollList: Display all posts
- ScrollEditor: Create new posts
- SpellCaster: Delete posts with spell
- WalletConnect: Web3 authentication

### 3. Storage Layer

**IPFS (InterPlanetary File System)**
- Decentralized content storage
- Content addressing
- Permanent data availability
- Infura gateway

### 4. Blockchain Layer

**zkSync Era**
- Layer 2 scaling solution
- Low gas fees
- Fast finality
- EVM compatibility

## Data Flow

### Publishing a Scroll

```
User Input (Markdown)
        │
        ▼
Content Hash (Spell)
        │
        ▼
Upload to IPFS
        │
        ▼
Get IPFS Hash
        │
        ▼
Smart Contract Transaction
        │
        ▼
Emit ScrollPublished Event
        │
        ▼
Update Frontend State
```

### Deleting a Scroll

```
User Clicks Delete
        │
        ▼
Prompt for Spell
        │
        ▼
Hash Spell (Keccak256)
        │
        ▼
Call castDeletionSpell()
        │
        ├─ Match? ─> Delete Scroll
        │            └─> Emit ScrollDeleted
        │
        └─ No Match ─> Revert Transaction
```

## Multi-Language Examples

Each language example demonstrates platform-specific patterns:

### Smart Contract Platforms

1. **Solidity (Ethereum/zkSync)**
   - ERC-20 tokens
   - Access control
   - Event emissions

2. **Vyper (Ethereum)**
   - Pythonic syntax
   - Safety-first design

3. **Rust (Solana/NEAR/Substrate)**
   - Anchor framework (Solana)
   - Near-SDK (NEAR)
   - Substrate pallets

4. **Move (Aptos/Sui)**
   - Resource-oriented programming
   - Object-centric (Sui)

### SDK/Client Examples

1. **Python (Web3.py)**
   - Contract deployment
   - Event listening
   - CLI tools

2. **Go (go-ethereum)**
   - Signature verification
   - RPC client
   - Transaction signing

3. **Java/Kotlin (Web3j)**
   - Android integration
   - Coroutine support

4. **Swift (web3.swift)**
   - iOS wallet SDK
   - Async/await patterns

## Security Architecture

### Smart Contract Security

- Input validation
- Reentrancy guards
- Access control modifiers
- Overflow protection (Solidity 0.8+)

### Frontend Security

- Environment variable protection
- No private key exposure
- HTTPS enforcement
- Content Security Policy

### Infrastructure Security

- IPFS content addressing
- Deterministic builds
- Audit trails
- Monitoring and alerts

## Scalability Patterns

### Layer 2 Scaling

**zkSync Era Benefits:**
- ~1000x cheaper gas
- Sub-second finality
- EVM compatibility
- Ethereum security

### IPFS Scaling

- Content deduplication
- Distributed storage
- Gateway redundancy
- Pinning services

## Development Workflow

```
Local Development
        │
        ▼
Unit Testing
        │
        ▼
Integration Testing
        │
        ▼
Testnet Deployment
        │
        ▼
Security Audit
        │
        ▼
Mainnet Deployment
```

## Monitoring & Observability

- Smart contract events
- Transaction monitoring
- Gas usage tracking
- Error logging
- Performance metrics

## Future Architecture

### Planned Improvements

1. **Zero-Knowledge Proofs**
   - Anonymous deletion
   - Privacy-preserving features

2. **Multi-Chain Support**
   - Cross-chain bridges
   - Chain abstraction

3. **Decentralized Indexing**
   - The Graph protocol
   - Custom subgraphs

4. **Layer 3 / App Chains**
   - Custom execution environment
   - Specialized optimizations

## Technology Stack Summary

| Layer | Technology | Purpose |
|-------|------------|---------|
| Frontend | Next.js 14 | React framework |
| Styling | Tailwind CSS | Utility-first CSS |
| Web3 UI | RainbowKit | Wallet connection |
| Web3 Hooks | Wagmi | React Ethereum hooks |
| Smart Contracts | Solidity 0.8.20 | Contract language |
| Development | Hardhat | Testing & deployment |
| Layer 2 | zkSync Era | Scaling solution |
| Storage | IPFS | Decentralized storage |
| CI/CD | GitHub Actions | Automation |

## Performance Considerations

- **Gas Optimization**: Minimal storage writes
- **Batching**: Multiple operations in single tx
- **Caching**: IPFS content caching
- **CDN**: Static asset delivery
- **Lazy Loading**: Component code splitting

---

For implementation details, see individual README files in each example directory.
