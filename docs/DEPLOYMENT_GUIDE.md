# Deployment Guide

Complete guide for deploying EchoScroll to production.

## Prerequisites

- Node.js 18+
- Git
- Ethereum wallet with funds
- IPFS account (Infura/Pinata)
- Domain name (optional)

## Environment Setup

### 1. Create Environment File

```bash
cp .env.example .env
```

### 2. Configure Variables

```env
# Blockchain
PRIVATE_KEY=your_deployer_private_key
NEXT_PUBLIC_CONTRACT_ADDRESS=deployed_contract_address

# IPFS
IPFS_PROJECT_ID=your_infura_project_id
IPFS_PROJECT_SECRET=your_infura_secret

# Network
NEXT_PUBLIC_CHAIN_ID=324  # zkSync Era mainnet
NEXT_PUBLIC_RPC_URL=https://mainnet.era.zksync.io

# Optional
ETHERSCAN_API_KEY=your_etherscan_key
```

## Smart Contract Deployment

### Local Testing

```bash
# Start local node
npx hardhat node

# Deploy to localhost
npx hardhat run scripts/deploy.ts --network localhost
```

### Testnet Deployment (zkSync Sepolia)

```bash
# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test

# Deploy
npx hardhat deploy --network zksync-sepolia
```

### Mainnet Deployment

```bash
# Final checks
npm run lint
npm test

# Deploy to mainnet
npx hardhat deploy --network zksync-mainnet

# Verify on explorer
npx hardhat verify --network zksync-mainnet DEPLOYED_ADDRESS
```

## Frontend Deployment

### Vercel (Recommended)

1. Push to GitHub
2. Import to Vercel
3. Configure environment variables
4. Deploy

```bash
# Or use Vercel CLI
npm i -g vercel
vercel --prod
```

### Netlify

```bash
# Build
npm run build

# Deploy
netlify deploy --prod --dir=.next
```

### Docker Deployment

```bash
# Build image
docker build -t echoscroll .

# Run container
docker run -p 3000:3000 \
  -e NEXT_PUBLIC_CONTRACT_ADDRESS=0x... \
  echoscroll
```

## Post-Deployment

### 1. Verify Contract

```bash
npx hardhat verify --network zksync-mainnet \
  DEPLOYED_ADDRESS \
  "Constructor" "Args"
```

### 2. Test Functionality

- Connect wallet
- Publish test scroll
- Verify on blockchain explorer
- Test deletion with spell

### 3. Monitor

- Set up error tracking (Sentry)
- Monitor transaction costs
- Track IPFS pinning status

## Security Checklist

- [ ] Private keys secured
- [ ] Environment variables set
- [ ] HTTPS enabled
- [ ] Contract verified
- [ ] Access control tested
- [ ] Rate limiting configured

## Troubleshooting

### Contract Deployment Fails

```bash
# Check gas price
cast gas-price --rpc-url $RPC_URL

# Increase gas limit
hardhat deploy --gas-limit 5000000
```

### Frontend Build Errors

```bash
# Clear cache
rm -rf .next node_modules
npm install
npm run build
```

### IPFS Upload Fails

- Check API credentials
- Verify network connectivity
- Try alternative gateway

## Backup & Recovery

### Contract Migration

```bash
# Export contract ABI
npx hardhat export-abi

# Save deployment artifacts
cp deployments/ backup/
```

### Data Backup

- IPFS hashes stored on-chain
- Frontend state in localStorage
- Contract events can be replayed

## Monitoring

### Blockchain

```bash
# Watch contract events
npx hardhat events --network mainnet

# Monitor gas usage
npx hardhat gas-reporter
```

### Application

- Use Vercel Analytics
- Set up uptime monitoring
- Track error rates

## Cost Estimation

### zkSync Era Mainnet

- Contract deployment: ~$5-10
- Scroll publication: ~$0.01-0.05
- Scroll deletion: ~$0.01-0.05

### IPFS

- Infura: Free tier available
- Pinata: $0.015/GB/month

## Rollback Plan

If issues occur:

1. Pause contract (if pausable)
2. Redirect frontend to maintenance page
3. Investigate and fix
4. Deploy patch
5. Resume operations

## Resources

- [zkSync Docs](https://era.zksync.io/docs/)
- [Hardhat Deployment](https://hardhat.org/guides/deploying.html)
- [Vercel Deployment](https://vercel.com/docs)

---

For questions: support@echoscroll.io
