# 🚀 EchoScroll Setup Guide

This guide will help you set up and run the EchoScroll project locally.

## Prerequisites

- Node.js 18+ and npm
- A Web3 wallet (MetaMask, Rainbow, etc.)
- Git

## Quick Start

### 1. Clone and Install

```bash
git clone https://github.com/pavlenkotm/EchoScroll.git
cd EchoScroll
npm install
```

### 2. Environment Configuration

Copy the example environment file:

```bash
cp .env.example .env.local
```

#### Required Configuration

1. **WalletConnect Project ID** (Recommended)
   - Visit https://cloud.walletconnect.com
   - Create a new project
   - Copy your Project ID
   - Update `NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID` in `.env.local`

2. **IPFS Configuration** (Optional)
   - For production: Get credentials from https://infura.io
   - Update `NEXT_PUBLIC_IPFS_PROJECT_ID` and `NEXT_PUBLIC_IPFS_PROJECT_SECRET`
   - For development: The app will use public IPFS gateways

3. **Smart Contract Address** (After Deployment)
   - Deploy the contract (see Deployment section)
   - Update `NEXT_PUBLIC_CONTRACT_ADDRESS` with deployed address

### 3. Run Development Server

```bash
npm run dev
```

Visit http://localhost:3000

### 4. Build for Production

```bash
npm run build
npm start
```

## Smart Contract Deployment

### Compile Contract

```bash
npm run compile
```

### Deploy to zkSync Testnet

1. Add testnet ETH to your wallet from https://portal.zksync.io/faucet
2. Add your private key to `.env.local`:
   ```
   PRIVATE_KEY=your_private_key_here
   ```
3. Deploy:
   ```bash
   npm run deploy
   ```

### Update Frontend

After deployment, update `.env.local` with the contract address:
```
NEXT_PUBLIC_CONTRACT_ADDRESS=0x...
```

## Project Structure

```
EchoScroll/
├── app/                    # Next.js 14 app directory
│   ├── layout.tsx         # Root layout
│   ├── page.tsx           # Home page
│   └── providers.tsx      # Web3 providers
├── components/            # React components
│   ├── CreateScroll.tsx  # Scroll creation form
│   ├── ScrollFeed.tsx    # Scroll listing
│   └── ScrollCard.tsx    # Individual scroll display
├── contracts/            # Solidity smart contracts
│   └── EchoScroll.sol   # Main contract
├── lib/                 # Utility libraries
│   ├── contract.ts     # Contract ABI and helpers
│   └── ipfs.ts        # IPFS client
├── utils/             # Utility functions
│   ├── wagmi.ts      # Wagmi configuration
│   └── helpers.ts    # Helper functions
└── examples/         # Multi-language examples

## Technology Stack

- **Frontend**: Next.js 14, React 18, TypeScript
- **Styling**: Tailwind CSS
- **Web3**: Wagmi, RainbowKit, Ethers.js
- **Storage**: IPFS
- **Blockchain**: zkSync Era (Ethereum L2)
- **Smart Contracts**: Solidity 0.8.20

## Features

### Core Functionality

1. **Wallet Connection**
   - Multiple wallet support via RainbowKit
   - zkSync Era network integration

2. **Scroll Publishing**
   - Markdown editor for content
   - IPFS storage for content
   - On-chain metadata storage
   - Secret spell (password) protection

3. **Scroll Management**
   - View all published scrolls
   - Delete with secret spell
   - Author verification

### Security Features

- Spell-based deletion (password hashed on-chain)
- Author-only deletion rights
- Immutable IPFS storage
- Gas-optimized smart contract

## Development Tips

### Testing Smart Contracts

```bash
# Compile contracts
npx hardhat compile

# Run tests (if available)
npx hardhat test

# Deploy to local network
npx hardhat node
npx hardhat run scripts/deploy.ts --network localhost
```

### Common Issues

1. **Font Loading Errors**
   - The app uses system fonts by default
   - No external font loading required

2. **IPFS Upload Failing**
   - Check IPFS credentials in `.env.local`
   - Or use public gateway (slower but no auth required)

3. **Transaction Failing**
   - Ensure you have testnet ETH
   - Check you're on zkSync Era Testnet
   - Verify contract address is correct

4. **Build Errors**
   - Run `npm install` to ensure all dependencies are installed
   - Clear `.next` folder: `rm -rf .next`
   - Rebuild: `npm run build`

## Multi-Language Examples

The `examples/` directory contains blockchain examples in 47+ programming languages:
- Smart contract languages (Solidity, Vyper, Rust, Move, etc.)
- SDK examples (Python, Go, Java, Kotlin, Swift, etc.)
- Functional programming (Haskell, Scala, OCaml, etc.)

Each example includes its own README with setup instructions.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Support

- GitHub Issues: https://github.com/pavlenkotm/EchoScroll/issues
- Documentation: See README.md and docs/

## Production Checklist

Before deploying to production:

- [ ] Get your own WalletConnect Project ID
- [ ] Set up IPFS with Infura or Pinata
- [ ] Deploy contract to zkSync Era mainnet
- [ ] Update all environment variables
- [ ] Test all features thoroughly
- [ ] Set up monitoring and analytics
- [ ] Configure proper error handling
- [ ] Set up backup for IPFS content

## Next Steps

1. Connect your wallet
2. Publish your first scroll
3. Explore the multi-language examples
4. Deploy your own version
5. Contribute to the project

Happy coding! ✨
