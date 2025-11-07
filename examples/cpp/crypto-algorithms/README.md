# C++ Cryptographic Algorithms

## Overview

C++ implementations of cryptographic algorithms used in blockchain and Web3, focusing on Ethereum's Keccak-256 hash function.

## Features

- ✅ Keccak-256 hash implementation
- ✅ Ethereum address derivation
- ✅ Function selector calculation
- ✅ Hex encoding utilities
- ✅ Header-only compatibility

## Build

```bash
mkdir build && cd build
cmake ..
make
```

## Run

```bash
./keccak256
```

## Usage

```cpp
#include "keccak256.h"

using namespace crypto;

// Hash a string
auto hash = keccak256("Hello, Ethereum!");

// Convert to hex
std::string hex_hash = to_hex(hash);

// Hash binary data
std::vector<uint8_t> data = {0x01, 0x02, 0x03};
auto hash2 = keccak256(data);
```

## Applications

- Ethereum address generation
- Function selector calculation
- Merkle tree construction
- Message signing preparation

## Resources

- [Keccak Specification](https://keccak.team/keccak.html)
- [Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf)

## License

MIT
