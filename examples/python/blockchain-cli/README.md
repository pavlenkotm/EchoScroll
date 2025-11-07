# Blockchain CLI Tool

## Overview

A command-line interface for interacting with Ethereum blockchain. Built with Python, Web3.py, and Click.

## Features

- ✅ Check ETH balance for any address
- ✅ Get block information
- ✅ Query transaction details
- ✅ Check current gas prices
- ✅ Network information
- ✅ Generate new wallets
- ✅ Support for any EVM chain

## Installation

```bash
pip install -r requirements.txt
```

Make executable:

```bash
chmod +x blockchain_cli.py
```

## Usage

### Get Help

```bash
python blockchain_cli.py --help
```

### Check Balance

```bash
python blockchain_cli.py balance 0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb
```

### Get Block Info

```bash
# Latest block
python blockchain_cli.py block

# Specific block
python blockchain_cli.py block 18000000
```

### Get Transaction

```bash
python blockchain_cli.py tx 0x5c504ed432cb51138bcf09aa5e8a410dd4a1e204ef84bfed1be16dfba1b22060
```

### Get Gas Price

```bash
python blockchain_cli.py gas
```

### Network Info

```bash
python blockchain_cli.py info
```

### Generate Wallet

```bash
python blockchain_cli.py generate-wallet
```

## Custom RPC

Use a different RPC endpoint:

```bash
python blockchain_cli.py --rpc https://eth-sepolia.g.alchemy.com/v2/YOUR_KEY balance 0x...
```

## Examples

```bash
# Check Vitalik's balance
./blockchain_cli.py balance 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045

# Get latest block
./blockchain_cli.py block

# Check gas price
./blockchain_cli.py gas

# Network info
./blockchain_cli.py info

# Generate new wallet
./blockchain_cli.py generate-wallet
```

## Supported Networks

Works with any EVM-compatible chain:
- Ethereum Mainnet
- Ethereum Testnets (Sepolia, Holesky)
- Polygon
- Arbitrum
- Optimism
- Base
- Avalanche
- BSC
- And more...

## License

MIT
