# EchoScroll - The Eternal Blockchain Library

A magical Web3 blog platform where posts are immortalized on the blockchain but can only be deleted with a secret spell. Built with Next.js, zkSync Era, and IPFS.

## Features

- **Blockchain Immortality**: Posts are published as on-chain records on zkSync Era
- **IPFS Storage**: Content is stored on IPFS for decentralized permanence
- **Spell-Based Deletion**: Only the author can delete their post by casting the correct secret spell
- **NFT-like Scrolls**: Each post is a unique scroll with on-chain metadata
- **Magical UI**: Beautiful animations and mystical design aesthetic
- **Web3 Authentication**: Connect with MetaMask or WalletConnect
- **Markdown Support**: Rich text editing with markdown support

## Tech Stack

### Frontend
- **Next.js 14** - React framework with App Router
- **TypeScript** - Type safety
- **Tailwind CSS** - Styling with custom magical theme
- **Framer Motion** - Smooth animations
- **RainbowKit** - Web3 wallet connection
- **Wagmi** - React hooks for Ethereum
- **SimpleMDE** - Markdown editor

### Backend/Blockchain
- **Solidity 0.8.20** - Smart contract language
- **Hardhat** - Development environment
- **zkSync Era** - Layer 2 scaling solution
- **IPFS** - Decentralized storage
- **Ethers.js** - Ethereum library

## Getting Started

### Prerequisites

- Node.js 18+ and npm/yarn
- MetaMask or compatible Web3 wallet
- zkSync Sepolia testnet ETH (for deployment)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/echoscroll.git
cd echoscroll
```

2. Install dependencies:
```bash
npm install
```

3. Set up environment variables:
```bash
cp .env.example .env
```

Edit `.env` and add:
- `PRIVATE_KEY` - Your deployment wallet private key
- `IPFS_PROJECT_ID` - Infura IPFS project ID
- `IPFS_PROJECT_SECRET` - Infura IPFS project secret
- Get IPFS credentials at: https://infura.io

4. Compile smart contracts:
```bash
npm run compile
```

5. Deploy to zkSync Sepolia testnet:
```bash
npm run deploy
```

6. Update `.env` with deployed contract address:
```bash
NEXT_PUBLIC_CONTRACT_ADDRESS=<your_deployed_contract_address>
```

7. Run development server:
```bash
npm run dev
```

8. Open [http://localhost:3000](http://localhost:3000)

## Smart Contract Architecture

### EchoScroll.sol

The main contract manages scrolls (posts) with the following key features:

#### Core Functions

- `publishScroll(ipfsHash, spellHash, title)` - Publish a new scroll
- `castDeletionSpell(scrollId, spell)` - Delete a scroll with secret spell
- `getActiveScrolls()` - Returns array of active scroll IDs
- `getScroll(scrollId)` - Get scroll details
- `getScrollsByAuthor(author)` - Get all scrolls by specific author

#### Events

- `ScrollPublished` - Emitted when new scroll is created
- `ScrollDeleted` - Emitted when scroll is successfully deleted
- `SpellCast` - Emitted on deletion attempt (success/failure)

## How It Works

### Publishing a Scroll

1. User writes content in markdown editor
2. Creates a secret deletion spell (hashed client-side)
3. Content uploaded to IPFS, returns hash
4. Transaction sent to smart contract
5. Scroll published on-chain

### Deleting a Scroll

1. Author clicks delete button
2. Modal prompts for secret spell
3. Spell is hashed and verified on-chain
4. If match: scroll deleted with vanishing animation
5. If mismatch: transaction reverts

## Project Structure

```
echoscroll/
├── app/                    # Next.js App Router
├── components/            # React components
├── contracts/             # Solidity contracts
├── lib/                   # Core libraries
├── scripts/               # Deployment scripts
└── utils/                 # Utilities
```

## Configuration

### zkSync Networks

**Testnet (Default)**
- Network: zkSync Era Sepolia
- RPC: https://sepolia.era.zksync.dev
- Explorer: https://sepolia.explorer.zksync.io

**Mainnet**
- Network: zkSync Era
- RPC: https://mainnet.era.zksync.io
- Explorer: https://explorer.zksync.io

## Roadmap

- [x] Core spell-based deletion mechanism
- [x] IPFS integration
- [x] Web3 authentication
- [ ] Zero-knowledge proofs for anonymous deletion
- [ ] NFT collection "EchoScrolls"
- [ ] AI summarizer for deleted content

## License

MIT License

---

Built with ✨ magic and 🔮 blockchain technology