# Vyper Smart Contract Example

## Overview

This directory contains a simple ERC-20 token implementation in **Vyper**, demonstrating an alternative to Solidity for Ethereum smart contract development.

## About Vyper

Vyper is a contract-oriented, pythonic programming language that targets the Ethereum Virtual Machine (EVM). It is designed to improve on Solidity with:

- **Security focus**: Vyper prioritizes security with deliberate language design choices
- **Pythonic syntax**: Clean, readable syntax similar to Python
- **Audibility**: Easier to audit due to deliberate limitations
- **No class inheritance**: Reduces complexity and potential attack vectors

## Files

- `SimpleToken.vy` - ERC-20 token implementation in Vyper

## Features

The SimpleToken contract includes:

- ✅ ERC-20 standard interface implementation
- ✅ Transfer, approve, and transferFrom functions
- ✅ Balance and allowance tracking
- ✅ Event emissions for transfers and approvals
- ✅ Safety checks for zero addresses and insufficient balances

## Setup

### Prerequisites

- Python 3.7+
- Vyper compiler

### Install Vyper

```bash
pip install vyper
```

## Compilation

Compile the Vyper contract:

```bash
vyper SimpleToken.vy
```

Generate ABI:

```bash
vyper -f abi SimpleToken.vy
```

Generate bytecode:

```bash
vyper -f bytecode SimpleToken.vy
```

## Deployment

Deploy using web3.py:

```python
from web3 import Web3
from vyper import compile_code

# Read contract
with open('SimpleToken.vy', 'r') as f:
    contract_code = f.read()

# Compile
compiled = compile_code(contract_code, ['abi', 'bytecode'])

# Deploy
w3 = Web3(Web3.HTTPProvider('http://localhost:8545'))
Token = w3.eth.contract(abi=compiled['abi'], bytecode=compiled['bytecode'])

# Constructor: name, symbol, decimals, total_supply
tx_hash = Token.constructor("MyToken", "MTK", 18, 1000000).transact()
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
```

## Key Differences from Solidity

1. **No modifiers** - Use inline checks instead
2. **No class inheritance** - Implements interfaces directly
3. **Bounds checking** - All array accesses are bounds-checked
4. **Overflow protection** - Built-in overflow protection
5. **Limited expressiveness** - Deliberately constrained to reduce attack surface

## Testing

Create a test file with pytest:

```python
import pytest
from ape import accounts, project

@pytest.fixture
def token(accounts):
    return accounts[0].deploy(project.SimpleToken, "Test", "TST", 18, 1000000)

def test_transfer(token, accounts):
    token.transfer(accounts[1], 100, sender=accounts[0])
    assert token.balanceOf(accounts[1]) == 100
```

## Resources

- [Vyper Documentation](https://docs.vyperlang.org/)
- [Vyper by Example](https://vyper.dev/)
- [Vyper GitHub](https://github.com/vyperlang/vyper)

## Security Considerations

- Always validate inputs
- Be aware of gas costs
- Test thoroughly before mainnet deployment
- Audit complex contracts

## License

MIT
