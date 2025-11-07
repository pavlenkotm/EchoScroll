#!/bin/bash

###############################################################################
# Ethereum Node Setup and Management Script
# Quickly setup and manage local Ethereum development nodes
###############################################################################

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

NODE_TYPE="${1:-hardhat}"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Ethereum Node Setup Script           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

setup_hardhat() {
    echo -e "${YELLOW}Setting up Hardhat node...${NC}"

    # Install Hardhat if not installed
    if ! npx hardhat --version &> /dev/null; then
        echo -e "${YELLOW}Installing Hardhat...${NC}"
        npm install --save-dev hardhat
    fi

    echo -e "${GREEN}✓ Hardhat ready${NC}"
    echo -e "${BLUE}→ Starting Hardhat node...${NC}"
    npx hardhat node
}

setup_ganache() {
    echo -e "${YELLOW}Setting up Ganache...${NC}"

    if ! command -v ganache &> /dev/null; then
        echo -e "${YELLOW}Installing Ganache...${NC}"
        npm install -g ganache
    fi

    echo -e "${GREEN}✓ Ganache ready${NC}"
    echo -e "${BLUE}→ Starting Ganache...${NC}"
    ganache --chain.chainId 1337 --wallet.deterministic
}

setup_anvil() {
    echo -e "${YELLOW}Setting up Anvil (Foundry)...${NC}"

    if ! command -v anvil &> /dev/null; then
        echo -e "${YELLOW}Foundry not found. Install from: https://getfoundry.sh${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓ Anvil ready${NC}"
    echo -e "${BLUE}→ Starting Anvil...${NC}"
    anvil
}

case $NODE_TYPE in
    hardhat)
        setup_hardhat
        ;;
    ganache)
        setup_ganache
        ;;
    anvil)
        setup_anvil
        ;;
    *)
        echo -e "Usage: $0 [hardhat|ganache|anvil]"
        exit 1
        ;;
esac
