# Bash Deployment Scripts

## Overview

Collection of bash scripts for automating blockchain development tasks including deployment, node management, and gas analysis.

## Scripts

### deploy-contract.sh

Automated smart contract deployment with testing and verification.

**Features:**
- Multi-network support (localhost, sepolia, mainnet)
- Pre-deployment testing
- Etherscan verification
- Deployment tracking
- Safety confirmations

**Usage:**
```bash
chmod +x deploy-contract.sh
./deploy-contract.sh [network]

# Examples
./deploy-contract.sh localhost
./deploy-contract.sh sepolia
./deploy-contract.sh mainnet
```

### setup-node.sh

Quick setup and launch of local Ethereum development nodes.

**Supported Nodes:**
- Hardhat
- Ganache
- Anvil (Foundry)

**Usage:**
```bash
chmod +x setup-node.sh
./setup-node.sh [node-type]

# Examples
./setup-node.sh hardhat
./setup-node.sh ganache
./setup-node.sh anvil
```

### gas-reporter.sh

Analyze gas usage and estimate costs.

**Features:**
- Current gas price fetching
- Transaction analysis
- Deployment cost estimation
- Multi-network support

**Usage:**
```bash
chmod +x gas-reporter.sh
./gas-reporter.sh [network] [tx-hash]

# Examples
./gas-reporter.sh sepolia 0x123...
./gas-reporter.sh mainnet
```

## Prerequisites

- bash 4.0+
- Node.js & npm
- curl
- jq (for JSON parsing)
- bc (for calculations)
- Hardhat/Foundry (depending on script)

## Installation

Make scripts executable:

```bash
chmod +x *.sh
```

Install dependencies:

```bash
# On Ubuntu/Debian
sudo apt-get install jq bc

# On macOS
brew install jq bc
```

## Environment Variables

Create `.env` file:

```bash
PRIVATE_KEY=your_private_key
ETHERSCAN_API_KEY=your_api_key
INFURA_API_KEY=your_infura_key
DEPLOYER_ADDRESS=your_address
```

## Common Workflows

### Deploy and Verify

```bash
# 1. Setup local node
./setup-node.sh hardhat

# 2. Deploy contract (in another terminal)
./deploy-contract.sh sepolia

# 3. Analyze gas usage
./gas-reporter.sh sepolia TX_HASH
```

### Quick Test Deploy

```bash
# Start node
./setup-node.sh hardhat &

# Deploy immediately
./deploy-contract.sh localhost
```

## Safety Features

- Pre-flight dependency checks
- Test execution before deployment
- Mainnet confirmation prompts
- Deployment logging
- Error handling with rollback

## Tips

- Always test on localhost first
- Use sepolia for testnet deployments
- Keep deployment logs for auditing
- Verify contracts after deployment
- Monitor gas prices before mainnet

## Extending Scripts

Add custom networks in `deploy-contract.sh`:

```bash
polygon)
    npx hardhat run scripts/deploy.js --network polygon
    ;;
```

Add custom checks:

```bash
check_balance() {
    # Check deployer has enough funds
}
```

## Resources

- [Hardhat Documentation](https://hardhat.org/)
- [Foundry Book](https://book.getfoundry.sh/)
- [Etherscan API](https://docs.etherscan.io/)

## License

MIT
