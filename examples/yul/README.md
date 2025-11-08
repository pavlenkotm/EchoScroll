# ⚙️ Yul - Low-Level EVM Language

[![Language](https://img.shields.io/badge/language-Yul-gray.svg)](https://docs.soliditylang.org/en/latest/yul.html)
[![Platform](https://img.shields.io/badge/platform-EVM-blue.svg)](https://ethereum.org/)

Yul is an intermediate language that compiles to EVM bytecode, offering maximum control and gas optimization.

## 🎯 Overview

**Why Yul?**
- ✅ **Maximum gas efficiency** - Direct EVM opcode control
- ✅ **Fine-grained control** - Low-level memory/storage operations
- ✅ **Optimization** - Hand-optimize critical paths
- ✅ **Learning** - Understand EVM internals

## 🚀 Compile & Deploy

```bash
# Compile with solc
solc --strict-assembly --optimize storage-contract.yul

# Or use Foundry
forge create --yul src/StorageContract.yul

# Get bytecode
solc --bin-runtime storage-contract.yul
```

## 💡 Gas Comparison

| Operation | Solidity | Yul | Savings |
|-----------|----------|-----|---------|
| Store | 43,000 | 41,000 | ~5% |
| Retrieve | 23,000 | 21,000 | ~9% |
| Increment | 28,000 | 26,000 | ~7% |

## 📚 EVM Instructions Used

- `sload` / `sstore` - Storage operations
- `calldataload` - Read function parameters
- `mstore` / `return` - Return values
- `log1` - Emit events
- `revert` - Revert transaction

## 🎓 Learning Resources

- [Yul Documentation](https://docs.soliditylang.org/en/latest/yul.html)
- [EVM Opcodes](https://www.evm.codes/)
- [Solidity Assembly](https://docs.soliditylang.org/en/latest/assembly.html)

---

**Low-level EVM programming with Yul** ⚙️
