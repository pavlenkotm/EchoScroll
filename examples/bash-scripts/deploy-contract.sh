#!/bin/bash

###############################################################################
# Smart Contract Deployment Script
# Automates deployment of Solidity contracts to various networks
###############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
NETWORK="${1:-localhost}"
CONTRACT_PATH="${2:-contracts/}"
GAS_LIMIT="${GAS_LIMIT:-3000000}"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Smart Contract Deployment Script     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check dependencies
check_dependencies() {
    echo -e "${YELLOW}Checking dependencies...${NC}"

    if ! command -v node &> /dev/null; then
        echo -e "${RED}✗ Node.js not found${NC}"
        exit 1
    fi

    if ! command -v npx &> /dev/null; then
        echo -e "${RED}✗ npx not found${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓ Dependencies OK${NC}"
    echo ""
}

# Load environment variables
load_env() {
    if [ -f .env ]; then
        echo -e "${YELLOW}Loading environment variables...${NC}"
        export $(cat .env | grep -v '^#' | xargs)
        echo -e "${GREEN}✓ Environment loaded${NC}"
    else
        echo -e "${YELLOW}⚠ No .env file found${NC}"
    fi
    echo ""
}

# Compile contracts
compile_contracts() {
    echo -e "${YELLOW}Compiling contracts...${NC}"

    npx hardhat compile

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Compilation successful${NC}"
    else
        echo -e "${RED}✗ Compilation failed${NC}"
        exit 1
    fi
    echo ""
}

# Run tests
run_tests() {
    echo -e "${YELLOW}Running tests...${NC}"

    npx hardhat test

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ All tests passed${NC}"
    else
        echo -e "${RED}✗ Tests failed${NC}"
        exit 1
    fi
    echo ""
}

# Deploy to network
deploy_contract() {
    local network=$1

    echo -e "${YELLOW}Deploying to ${network}...${NC}"

    case $network in
        localhost)
            echo -e "${BLUE}→ Deploying to local network${NC}"
            npx hardhat run scripts/deploy.js --network localhost
            ;;
        sepolia)
            echo -e "${BLUE}→ Deploying to Sepolia testnet${NC}"
            npx hardhat run scripts/deploy.js --network sepolia
            ;;
        mainnet)
            echo -e "${RED}⚠ WARNING: Deploying to MAINNET!${NC}"
            read -p "Are you sure? (yes/no): " confirm
            if [ "$confirm" != "yes" ]; then
                echo -e "${YELLOW}Deployment cancelled${NC}"
                exit 0
            fi
            npx hardhat run scripts/deploy.js --network mainnet
            ;;
        *)
            echo -e "${RED}✗ Unknown network: ${network}${NC}"
            echo -e "Available networks: localhost, sepolia, mainnet"
            exit 1
            ;;
    esac

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Deployment successful${NC}"
    else
        echo -e "${RED}✗ Deployment failed${NC}"
        exit 1
    fi
    echo ""
}

# Verify contract on Etherscan
verify_contract() {
    local network=$1

    if [ "$network" == "localhost" ]; then
        echo -e "${YELLOW}⚠ Skipping verification for localhost${NC}"
        return
    fi

    echo -e "${YELLOW}Verifying contract on Etherscan...${NC}"

    if [ -z "$CONTRACT_ADDRESS" ]; then
        echo -e "${RED}✗ CONTRACT_ADDRESS not set${NC}"
        return
    fi

    npx hardhat verify --network $network $CONTRACT_ADDRESS

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Verification successful${NC}"
    else
        echo -e "${YELLOW}⚠ Verification failed (contract may already be verified)${NC}"
    fi
    echo ""
}

# Save deployment info
save_deployment() {
    local network=$1
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local deploy_file="deployments/${network}_${timestamp}.json"

    mkdir -p deployments

    echo -e "${YELLOW}Saving deployment info...${NC}"
    echo "{
  \"network\": \"${network}\",
  \"timestamp\": \"${timestamp}\",
  \"deployer\": \"${DEPLOYER_ADDRESS}\",
  \"contractAddress\": \"${CONTRACT_ADDRESS}\"
}" > $deploy_file

    echo -e "${GREEN}✓ Deployment saved to ${deploy_file}${NC}"
    echo ""
}

# Main execution
main() {
    check_dependencies
    load_env
    compile_contracts

    # Ask if user wants to run tests
    read -p "Run tests before deployment? (y/n): " run_test
    if [ "$run_test" == "y" ]; then
        run_tests
    fi

    deploy_contract $NETWORK

    # Ask about verification
    if [ "$NETWORK" != "localhost" ]; then
        read -p "Verify contract on Etherscan? (y/n): " do_verify
        if [ "$do_verify" == "y" ]; then
            verify_contract $NETWORK
        fi
    fi

    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     Deployment Complete! 🎉            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
}

# Run main function
main

# Usage:
# ./deploy-contract.sh [network]
# Example: ./deploy-contract.sh sepolia
