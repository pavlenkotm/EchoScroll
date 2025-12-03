# 🎭 Motoko Smart Contracts (DFINITY / Internet Computer)

[![Language](https://img.shields.io/badge/language-Motoko-blue.svg)](https://internetcomputer.org/docs/current/motoko/main/motoko)
[![Platform](https://img.shields.io/badge/platform-Internet_Computer-purple.svg)](https://internetcomputer.org/)
[![ICP](https://img.shields.io/badge/blockchain-ICP-orange.svg)](https://internetcomputer.org/)

A modern, actor-based programming language designed specifically for the Internet Computer Protocol (ICP) by DFINITY.

## 🎯 Overview

Motoko is a **type-safe, actor-based** language that makes it easy to build efficient and secure decentralized applications on the Internet Computer.

**Key Features:**
- ✅ Actor-based concurrency model
- ✅ Automatic memory management (garbage collection)
- ✅ Strong static typing with type inference
- ✅ Async/await for inter-canister calls
- ✅ Orthogonal persistence (state persists automatically)
- ✅ Modern syntax inspired by TypeScript/Swift

## 🚀 Quick Start

```bash
# Install dfx (DFINITY SDK)
sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"

# Verify installation
dfx --version

# Create new project
dfx new my_project
cd my_project

# Start local replica
dfx start --background

# Deploy canister
dfx deploy

# Interact with canister
dfx canister call my_project_backend greet '("World")'
```

## 📦 Example: Counter Canister

```motoko
actor Counter {
    stable var count : Nat = 0;

    public func increment() : async Nat {
        count += 1;
        return count;
    };

    public query func get() : async Nat {
        return count;
    };
};
```

## 🏗️ Project Structure

```
my_project/
├── dfx.json                    # Project configuration
├── src/
│   ├── my_project_backend/
│   │   └── main.mo            # Motoko source code
│   └── my_project_frontend/
│       └── index.html         # Frontend assets
└── .dfx/                      # Local deployment artifacts
```

## 💡 Core Concepts

### Actors
Actors are the fundamental building blocks in Motoko. Each actor is an isolated canister with its own state and message queue.

```motoko
actor MyActor {
    var state : Nat = 0;

    public func update() : async () {
        state += 1;
    };
};
```

### Stable Variables
Variables marked as `stable` persist across canister upgrades:

```motoko
actor {
    stable var persistentData : Nat = 0;  // Survives upgrades
    var volatileData : Nat = 0;           // Reset on upgrade
};
```

### Query vs Update Calls
- **Query calls**: Read-only, fast, don't modify state
- **Update calls**: Can modify state, go through consensus

```motoko
public query func read() : async Nat { /* fast read */ };
public func write() : async () { /* slower write */ };
```

## 📊 Advantages

| Feature | Motoko | Solidity |
|---------|--------|----------|
| **Memory Safety** | ✅ Built-in GC | ⚠️ Manual |
| **Async/Await** | ✅ Native | ❌ No |
| **Upgrade Safety** | ✅ Stable vars | ⚠️ Complex |
| **Type System** | ✅ Modern | ⚠️ Limited |
| **Actor Model** | ✅ Yes | ❌ No |

## 🔧 Advanced Features

### Inter-Canister Calls

```motoko
import OtherCanister "canister:other";

actor {
    public func callOther() : async Text {
        let result = await OtherCanister.getData();
        return result;
    };
};
```

### Error Handling

```motoko
public func divide(a : Nat, b : Nat) : async ?Nat {
    if (b == 0) {
        return null;
    } else {
        return ?(a / b);
    };
};
```

## 📚 Common Patterns

### Token Ledger

```motoko
actor Token {
    stable var balances : [(Principal, Nat)] = [];

    public shared(msg) func transfer(to : Principal, amount : Nat) : async Bool {
        // Transfer logic
        return true;
    };

    public query func balanceOf(account : Principal) : async Nat {
        // Query balance
        return 0;
    };
};
```

### Access Control

```motoko
actor {
    stable var owner : Principal = Principal.fromText("aaaaa-aa");

    public shared(msg) func adminOnly() : async () {
        assert(msg.caller == owner);
        // Admin logic
    };
};
```

## 🧪 Testing

```bash
# Unit tests with Motoko
dfx canister call my_canister test

# Integration tests
npm run test
```

## 📈 Deployment

### Local Deployment
```bash
dfx start --background
dfx deploy
```

### Mainnet Deployment
```bash
dfx deploy --network ic
```

### Cycles Management
```bash
# Check cycles balance
dfx canister status my_canister --network ic

# Top up cycles
dfx canister deposit-cycles 1000000000 my_canister --network ic
```

## 🌐 ICP Ecosystem

- **Canisters**: Smart contracts on ICP
- **Cycles**: Computation fuel (stable cost)
- **Internet Identity**: Decentralized authentication
- **Reverse Gas Model**: Canisters pay for computation

## 📚 Resources

- [Motoko Documentation](https://internetcomputer.org/docs/current/motoko/main/motoko)
- [Motoko Playground](https://m7sm4-2iaaa-aaaab-qabra-cai.ic0.app/)
- [DFINITY Developer Forum](https://forum.dfinity.org/)
- [ICP Examples](https://github.com/dfinity/examples)
- [Motoko Base Library](https://internetcomputer.org/docs/current/motoko/main/base/)

## 🔗 Related Technologies

- **Rust**: Alternative language for ICP canisters
- **Candid**: Interface description language for ICP
- **Internet Identity**: Web3 authentication system

## 📜 License

MIT License

---

**Built for the Internet Computer** 🎭


*Last updated: 2025-12-03*
