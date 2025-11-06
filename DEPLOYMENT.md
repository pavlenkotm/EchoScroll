# Deployment Guide

Complete guide to deploying EchoScroll to production.

## Prerequisites

- Node.js 18+
- Private key with ETH on zkSync network
- IPFS credentials (Infura, Pinata, etc.)
- Vercel/Netlify account (for frontend)

## Part 1: Deploy Smart Contract

### Step 1: Get zkSync ETH

**For Testnet:**
1. Get Sepolia ETH from faucet
2. Bridge to zkSync: https://portal.zksync.io/bridge
3. Wait for confirmation (~15 minutes)

**For Mainnet:**
1. Bridge ETH to zkSync Era
2. Ensure you have enough for gas (~0.01 ETH)

### Step 2: Configure Environment

Create `.env` file:

```env
# Your wallet private key (KEEP SECRET!)
PRIVATE_KEY=0x1234567890abcdef...

# Network (zkSyncTestnet or zkSyncMainnet)
NEXT_PUBLIC_ZKSYNC_NETWORK=zkSyncTestnet
```

### Step 3: Compile Contract

```bash
npm run compile
```

Verify compilation success:
```bash
ls -l artifacts/contracts/EchoScroll.sol/
```

### Step 4: Deploy Contract

**To Testnet:**
```bash
npm run deploy
```

**To Mainnet:**
```bash
npx hardhat run scripts/deploy.ts --network zkSyncMainnet
```

**Save the contract address!** You'll see output like:
```
✨ EchoScroll deployed at: 0xABCDEF123456789...
```

### Step 5: Verify Contract (Optional)

```bash
npx hardhat verify --network zkSyncTestnet <CONTRACT_ADDRESS>
```

## Part 2: Configure IPFS

### Option A: Infura IPFS (Recommended)

1. Go to https://infura.io
2. Create account and new IPFS project
3. Get credentials:
   - Project ID
   - Project Secret

Add to `.env`:
```env
IPFS_PROJECT_ID=your_project_id
IPFS_PROJECT_SECRET=your_project_secret
NEXT_PUBLIC_IPFS_API_URL=https://ipfs.infura.io:5001
NEXT_PUBLIC_IPFS_GATEWAY=https://ipfs.infura.io/ipfs/
```

### Option B: Pinata

1. Sign up at https://pinata.cloud
2. Get API key and secret
3. Update `lib/ipfs.ts` with Pinata SDK

### Option C: Web3.Storage

1. Get free account at https://web3.storage
2. Generate API token
3. Update `lib/ipfs.ts` accordingly

## Part 3: Deploy Frontend

### Update Environment Variables

Create `.env.production`:

```env
# Contract address from deployment
NEXT_PUBLIC_CONTRACT_ADDRESS=0xYourContractAddress

# Network
NEXT_PUBLIC_ZKSYNC_NETWORK=zkSyncTestnet

# IPFS
NEXT_PUBLIC_IPFS_API_URL=https://ipfs.infura.io:5001
NEXT_PUBLIC_IPFS_GATEWAY=https://ipfs.infura.io/ipfs/
IPFS_PROJECT_ID=your_project_id
IPFS_PROJECT_SECRET=your_project_secret

# WalletConnect (get from https://cloud.walletconnect.com)
NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID=your_walletconnect_id
```

### Option A: Deploy to Vercel

1. Push code to GitHub

2. Go to https://vercel.com

3. Import repository

4. Configure:
   - Framework Preset: Next.js
   - Build Command: `npm run build`
   - Output Directory: `.next`

5. Add environment variables (from `.env.production`)

6. Deploy!

7. Get your URL: `https://echoscroll.vercel.app`

### Option B: Deploy to Netlify

1. Build locally:
```bash
npm run build
```

2. Install Netlify CLI:
```bash
npm install -g netlify-cli
```

3. Deploy:
```bash
netlify deploy --prod
```

4. Set environment variables in Netlify dashboard

### Option C: Self-Hosted

1. Build production:
```bash
npm run build
```

2. Start server:
```bash
npm start
```

3. Use PM2 for process management:
```bash
npm install -g pm2
pm2 start npm --name "echoscroll" -- start
pm2 save
```

4. Configure nginx reverse proxy:
```nginx
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

5. Enable HTTPS with Let's Encrypt:
```bash
sudo certbot --nginx -d yourdomain.com
```

## Part 4: Post-Deployment

### 1. Test the Application

- [ ] Connect wallet
- [ ] Create test scroll
- [ ] View in library
- [ ] Delete with spell
- [ ] Check on blockchain explorer

### 2. Monitor Contract

Set up monitoring:
- zkSync Explorer
- Tenderly for alerts
- Custom analytics dashboard

### 3. Set Up Analytics (Optional)

Add to `app/layout.tsx`:

```typescript
// Google Analytics
import { Analytics } from '@vercel/analytics/react';

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Analytics />
      </body>
    </html>
  );
}
```

### 4. Update Contract Address in Code

Ensure `.env` or hosting platform has:
```env
NEXT_PUBLIC_CONTRACT_ADDRESS=0xYourDeployedAddress
```

### 5. Update Documentation

Update README.md with:
- Live demo URL
- Deployed contract address
- Network information

## Security Checklist

- [ ] Private keys never committed to git
- [ ] `.env` in `.gitignore`
- [ ] Contract verified on explorer
- [ ] IPFS credentials secured
- [ ] Environment variables set on hosting platform
- [ ] Test all features on production
- [ ] Monitor for unusual activity

## Costs Estimation

### Smart Contract Deployment
- zkSync Testnet: Free (testnet ETH)
- zkSync Mainnet: ~$5-20 in ETH

### IPFS Storage
- Infura: Free tier (5GB)
- Pinata: Free tier (1GB)
- Web3.Storage: Free

### Hosting
- Vercel: Free (hobby)
- Netlify: Free tier
- Self-hosted: Variable

### Ongoing Costs
- IPFS pinning: $0-10/month
- Hosting: $0-20/month
- Domain: ~$12/year

## Troubleshooting

### Contract Deployment Fails
- Check you have enough ETH
- Verify private key is correct
- Ensure correct network in config

### Frontend Can't Connect to Contract
- Verify contract address in env vars
- Check network matches (testnet/mainnet)
- Clear browser cache

### IPFS Upload Fails
- Verify credentials
- Check API limits
- Try different gateway

### Wallet Connection Issues
- Update WalletConnect project ID
- Check network configuration
- Clear browser cache/cookies

## Updating the App

1. Make changes locally
2. Test thoroughly
3. Commit and push to GitHub
4. Vercel/Netlify auto-deploys
5. Or manually: `npm run build && npm start`

## Rolling Back

If deployment fails:

1. Revert to previous commit
2. Redeploy
3. Or use Vercel's instant rollback feature

## Getting Help

- GitHub Issues
- zkSync Discord
- Community forums

---

Good luck with your deployment! 🚀✨
