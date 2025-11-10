import { getDefaultConfig } from '@rainbow-me/rainbowkit';
import { mainnet, sepolia } from 'wagmi/chains';

// Define zkSync Era chains
export const zkSyncEra = {
  id: 324,
  name: 'zkSync Era',
  nativeCurrency: { name: 'Ether', symbol: 'ETH', decimals: 18 },
  rpcUrls: {
    default: { http: ['https://mainnet.era.zksync.io'] },
    public: { http: ['https://mainnet.era.zksync.io'] },
  },
  blockExplorers: {
    default: { name: 'zkSync Explorer', url: 'https://explorer.zksync.io' },
  },
  testnet: false,
} as const;

export const zkSyncEraTestnet = {
  id: 300,
  name: 'zkSync Era Sepolia Testnet',
  nativeCurrency: { name: 'Ether', symbol: 'ETH', decimals: 18 },
  rpcUrls: {
    default: { http: ['https://sepolia.era.zksync.dev'] },
    public: { http: ['https://sepolia.era.zksync.dev'] },
  },
  blockExplorers: {
    default: {
      name: 'zkSync Explorer',
      url: 'https://sepolia.explorer.zksync.io'
    },
  },
  testnet: true,
} as const;

export const config = getDefaultConfig({
  appName: 'EchoScroll',
  projectId: process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID || 'a01e1cb88a3f8b6c1e94e5f123456789', // Get your own from https://cloud.walletconnect.com
  chains: [zkSyncEraTestnet, zkSyncEra, mainnet, sepolia],
  ssr: true,
});
