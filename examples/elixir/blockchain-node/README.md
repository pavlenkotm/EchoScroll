# 💧 Elixir Blockchain Node

[![Language](https://img.shields.io/badge/language-Elixir-purple.svg)](https://elixir-lang.org/)
[![OTP](https://img.shields.io/badge/platform-BEAM/OTP-red.svg)](https://www.erlang.org/)

Functional blockchain implementation using Elixir and OTP for fault-tolerant distributed systems.

## Features

- ✅ Proof-of-Work mining
- ✅ Chain validation
- ✅ GenServer for state management
- ✅ Concurrent block processing
- ✅ Supervisor trees

## Run

```bash
mix deps.get
iex -S mix

# Add blocks
Blockchain.Chain.add_block("Transaction 1")
Blockchain.Chain.get_chain()
```

---

**Elixir + OTP** 💧
