# 🔍 Clarity Smart Contract (Stacks)

[![Language](https://img.shields.io/badge/language-Clarity-blue.svg)](https://clarity-lang.org/)
[![Platform](https://img.shields.io/badge/platform-Stacks-purple.svg)](https://www.stacks.co/)
[![Bitcoin](https://img.shields.io/badge/settled-Bitcoin-orange.svg)](https://bitcoin.org/)

A decidable smart contract language for Stacks, bringing smart contracts to Bitcoin.

## 🎯 Overview

Clarity is a **decidable** language, meaning you can know with certainty what a program will do before executing it.

**Key Features:**
- ✅ No compiler needed (interpreted)
- ✅ Decidable (predictable outcomes)
- ✅ Post-conditions for security
- ✅ Bitcoin settlement
- ✅ No reentrancy attacks possible

## 🚀 Quick Start

```bash
# Install Clarinet
brew install clarinet

# Create new project
clarinet new my-project
cd my-project

# Add contract
clarinet contract new counter

# Test
clarinet test

# Deploy
clarinet deploy
```

## 📊 Advantages

| Feature | Clarity | Solidity |
|---------|---------|----------|
| **Decidability** | ✅ Yes | ❌ No |
| **Compiler Bugs** | ✅ None | ⚠️ Possible |
| **Reentrancy** | ✅ Impossible | ⚠️ Must Guard |
| **Bitcoin Secured** | ✅ Yes | ❌ No |

## 📚 Resources

- [Clarity Book](https://book.clarity-lang.org/)
- [Stacks Documentation](https://docs.stacks.co/)
- [Hiro Tools](https://www.hiro.so/)

---

**Built with Clarity for Bitcoin** 🔍


*Last updated: 2025-11-29*
