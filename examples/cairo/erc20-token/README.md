# 🏺 Cairo ERC-20 Token (StarkNet)

[![Language](https://img.shields.io/badge/language-Cairo-orange.svg)](https://cairo-lang.org/)
[![Platform](https://img.shields.io/badge/platform-StarkNet-purple.svg)](https://starknet.io/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A production-ready ERC-20 token implementation in Cairo for StarkNet, showcasing Cairo's unique syntax and proving system.

## 🎯 Overview

This example demonstrates:
- **Cairo 2.0 syntax** with attributes and traits
- **StarkNet contract structure** with storage, events, and external functions
- **Zero-Knowledge proofs** via STARK (Scalable Transparent ARgument of Knowledge)
- **Gas-efficient operations** optimized for L2 scaling
- **Complete ERC-20 implementation** (transfer, approve, transferFrom)

## 🚀 Features

### Smart Contract Capabilities
- ✅ Standard ERC-20 interface
- ✅ Transfer and approval mechanisms
- ✅ Event emission for indexing
- ✅ Safe arithmetic operations
- ✅ Zero address protection

### Cairo-Specific Benefits
- **Provable computation**: All operations are mathematically proven
- **Scalability**: L2 solution with low gas costs
- **Security**: Cairo's type system prevents common vulnerabilities
- **Efficiency**: Optimized for StarkNet's VM

## 📋 Prerequisites

```bash
# Install Cairo and Scarb (Cairo package manager)
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh

# Verify installation
scarb --version
```

## 🛠️ Installation

```bash
cd examples/cairo/erc20-token

# Install dependencies
scarb build
```

## 💻 Usage

### Compile Contract

```bash
scarb build
```

This generates:
- `target/dev/erc20_token.sierra.json` - Sierra intermediate representation
- `target/dev/erc20_token.casm.json` - Cairo Assembly (executable)

### Deploy to StarkNet

```bash
# Using StarkNet CLI
starknet deploy \
    --contract target/dev/erc20_token.sierra.json \
    --inputs \
        1234567890123456789 \  # name (felt252)
        5678901234567890 \     # symbol (felt252)
        18 \                   # decimals
        1000000000000000000000000 \ # initial supply (u256 low)
        0 \                    # initial supply (u256 high)
        <RECIPIENT_ADDRESS>    # recipient address
```

### Interact with Contract

```python
from starknet_py.contract import Contract
from starknet_py.net.account.account import Account

# Connect to contract
contract = await Contract.from_address(
    address="0x...",
    provider=account
)

# Read balance
balance = await contract.functions["balance_of"].call(account.address)
print(f"Balance: {balance.balance}")

# Transfer tokens
tx = await contract.functions["transfer"].invoke(
    recipient="0x...",
    amount=1000000000000000000  # 1 token with 18 decimals
)
await tx.wait_for_acceptance()
```

## 🧪 Testing

```bash
# Run tests (Cairo tests)
scarb cairo-test

# Run with coverage
scarb cairo-test --coverage
```

## 📊 StarkNet Advantages

| Feature | Benefit |
|---------|---------|
| **L2 Scaling** | 300-500 TPS (vs 15 TPS on Ethereum L1) |
| **Gas Costs** | ~10x cheaper than Ethereum mainnet |
| **Security** | Mathematical proofs guarantee correctness |
| **Privacy** | Optional privacy features via ZK proofs |
| **Finality** | Fast finality with L1 security guarantees |

## 🔍 Key Cairo Concepts

### 1. **Storage Variables**
```cairo
#[storage]
struct Storage {
    balances: LegacyMap<ContractAddress, u256>,
}
```

### 2. **Events**
```cairo
#[event]
#[derive(Drop, starknet::Event)]
enum Event {
    Transfer: Transfer,
}
```

### 3. **External Functions**
```cairo
#[external(v0)]
fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
    // Function body
}
```

## 📚 StarkNet Resources

- [Cairo Book](https://book.cairo-lang.org/) - Official Cairo documentation
- [StarkNet Docs](https://docs.starknet.io/) - Platform documentation
- [Cairo by Example](https://cairo-by-example.com/) - Learn through examples
- [StarkWare YouTube](https://www.youtube.com/c/StarkWare) - Video tutorials

## 🔐 Security Considerations

- ✅ **Overflow protection**: Cairo 2.0 has built-in overflow checks
- ✅ **Zero address checks**: Prevents burning tokens accidentally
- ✅ **Allowance verification**: Checks before transferFrom
- ✅ **Event emission**: All state changes emit events

## 🎓 Learning Path

1. **Basics**: Understand Cairo syntax and felt252 type
2. **Storage**: Learn about contract storage and mappings
3. **Functions**: External vs internal functions
4. **Events**: Emission and indexing
5. **Testing**: Write Cairo tests
6. **Deployment**: Deploy to testnet and mainnet

## 🌟 Use Cases

- **Token launches** on StarkNet
- **DeFi protocols** requiring fungible tokens
- **NFT marketplace currencies**
- **DAO governance tokens**
- **Gaming in-game currencies**

## 📈 Performance Metrics

| Operation | StarkNet Gas | Ethereum Gas |
|-----------|-------------|--------------|
| Transfer | ~1,000 | ~21,000 |
| Approve | ~800 | ~46,000 |
| Mint | ~1,200 | ~50,000 |

## 🤝 Contributing

Contributions welcome! Please read our [Contributing Guide](../../../CONTRIBUTING.md).

## 📜 License

MIT License - see [LICENSE](../../../LICENSE) for details.

## 🔗 Links

- **StarkNet Mainnet**: [Voyager Explorer](https://voyager.online/)
- **Testnet Faucet**: [StarkNet Faucet](https://faucet.goerli.starknet.io/)
- **Bridge**: [StarkGate Bridge](https://starkgate.starknet.io/)

---

**Built with Cairo 2.0 for StarkNet** 🏺
