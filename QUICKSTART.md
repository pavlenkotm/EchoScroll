# EchoScroll Quick Start Guide

Get up and running with EchoScroll in 5 minutes!

## Prerequisites

- Node.js 18+ installed
- MetaMask browser extension
- Some Sepolia ETH (get from faucet)

## 1. Installation

```bash
git clone <your-repo-url>
cd echoscroll
npm install
```

## 2. Get IPFS Credentials (Optional but Recommended)

1. Go to https://infura.io
2. Sign up for free account
3. Create new IPFS project
4. Copy Project ID and Secret

## 3. Configure Environment

```bash
cp .env.example .env
```

Edit `.env`:
```env
# For development, you can leave these empty to use public IPFS
NEXT_PUBLIC_IPFS_PROJECT_ID=your_project_id
NEXT_PUBLIC_IPFS_PROJECT_SECRET=your_secret

# Only needed for contract deployment
PRIVATE_KEY=your_private_key_here
```

## 4. Run Development Server

```bash
npm run dev
```

Open http://localhost:3000

## 5. Using the App

### Connect Wallet
1. Click "Connect Wallet" button
2. Select MetaMask
3. Approve connection
4. Switch to zkSync Sepolia testnet if prompted

### Create Your First Scroll

1. Click "Inscribe Scroll" tab
2. Enter a title: "My First Magical Scroll"
3. Write content in markdown
4. Create a secret spell (remember it!)
   - Example: "MySecret123!"
   - Must be 8+ characters
5. Click "Publish Scroll to Blockchain"
6. Approve transaction in MetaMask
7. Wait for confirmation

### View Scrolls

1. Click "Scroll Library" tab
2. See all published scrolls
3. Click to read full content

### Delete a Scroll

1. Find your scroll in the library
2. Click the trash icon
3. Enter your exact secret spell
4. Watch the magical vanishing animation!

## Need Testnet ETH?

Get free zkSync Sepolia ETH:
1. Bridge Sepolia ETH: https://portal.zksync.io/bridge
2. Or use faucet: https://docs.zksync.io/build/tooling/network-faucets.html

## Troubleshooting

### "Failed to upload to IPFS"
- Check your IPFS credentials in `.env`
- Or remove them to use public IPFS gateway

### "Transaction failed"
- Make sure you have enough zkSync Sepolia ETH
- Check you're connected to zkSync Sepolia network

### "Spell was incorrectly cast"
- Your deletion spell doesn't match
- Remember: it's case-sensitive!
- Try to remember the exact spell you used

## Next Steps

- Deploy your own contract (see README.md)
- Customize the magical theme
- Add your own features

## Support

Issues? Open a GitHub issue or check the docs!

---

Happy spell-casting! ✨🔮
