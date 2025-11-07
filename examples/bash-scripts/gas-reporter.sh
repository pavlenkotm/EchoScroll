#!/bin/bash

###############################################################################
# Gas Usage Reporter
# Analyze and report gas usage for smart contract deployments and transactions
###############################################################################

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

NETWORK="${1:-sepolia}"
TX_HASH="$2"

echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}     Gas Usage Reporter                ${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo ""

get_gas_price() {
    echo -e "${YELLOW}Fetching gas price for ${NETWORK}...${NC}"

    case $NETWORK in
        mainnet)
            API_URL="https://api.etherscan.io/api"
            ;;
        sepolia)
            API_URL="https://api-sepolia.etherscan.io/api"
            ;;
        *)
            echo -e "${YELLOW}Using localhost${NC}"
            return
            ;;
    esac

    GAS_PRICE=$(curl -s "${API_URL}?module=proxy&action=eth_gasPrice" | jq -r '.result')
    GAS_PRICE_GWEI=$(echo "scale=2; $((16#${GAS_PRICE:2})) / 1000000000" | bc)

    echo -e "${GREEN}Current Gas Price: ${GAS_PRICE_GWEI} gwei${NC}"
    echo ""
}

analyze_transaction() {
    if [ -z "$TX_HASH" ]; then
        echo -e "${YELLOW}No transaction hash provided${NC}"
        return
    fi

    echo -e "${YELLOW}Analyzing transaction: ${TX_HASH}${NC}"

    # Get transaction receipt
    RECEIPT=$(cast receipt $TX_HASH --rpc-url $NETWORK 2>/dev/null || echo "")

    if [ -z "$RECEIPT" ]; then
        echo -e "${YELLOW}Transaction not found${NC}"
        return
    fi

    GAS_USED=$(echo "$RECEIPT" | grep "gasUsed" | awk '{print $2}')
    GAS_PRICE=$(echo "$RECEIPT" | grep "effectiveGasPrice" | awk '{print $2}')

    echo -e "${GREEN}Gas Used: ${GAS_USED}${NC}"
    echo -e "${GREEN}Gas Price: ${GAS_PRICE} wei${NC}"

    # Calculate cost in ETH
    COST_WEI=$((GAS_USED * GAS_PRICE))
    COST_ETH=$(echo "scale=6; $COST_WEI / 1000000000000000000" | bc)

    echo -e "${GREEN}Total Cost: ${COST_ETH} ETH${NC}"
    echo ""
}

estimate_deployment() {
    echo -e "${YELLOW}Estimating deployment cost...${NC}"
    echo -e "${BLUE}→ Running gas reporter...${NC}"

    npx hardhat test --network $NETWORK

    echo ""
}

get_gas_price
analyze_transaction
estimate_deployment

echo -e "${GREEN}═══════════════════════════════════════${NC}"
