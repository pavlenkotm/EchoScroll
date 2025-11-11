/**
 * Shorten Ethereum address for display
 */
export const shortenAddress = (address: string, chars = 4): string => {
  if (!address) return '';
  return `${address.slice(0, chars + 2)}...${address.slice(-chars)}`;
};

/**
 * Format timestamp to readable date
 */
export const formatDate = (timestamp: bigint | number): string => {
  const date = typeof timestamp === 'bigint'
    ? new Date(Number(timestamp) * 1000)
    : new Date(timestamp);

  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
};

/**
 * Format relative time (e.g., "2 hours ago")
 */
export const formatRelativeTime = (timestamp: bigint | number): string => {
  const date = typeof timestamp === 'bigint'
    ? new Date(Number(timestamp) * 1000)
    : new Date(timestamp);

  const now = new Date();
  const seconds = Math.floor((now.getTime() - date.getTime()) / 1000);

  if (seconds < 60) return 'just now';
  if (seconds < 3600) return `${Math.floor(seconds / 60)} minutes ago`;
  if (seconds < 86400) return `${Math.floor(seconds / 3600)} hours ago`;
  if (seconds < 604800) return `${Math.floor(seconds / 86400)} days ago`;

  return formatDate(timestamp);
};

/**
 * Validate Ethereum address
 */
export const isValidAddress = (address: string): boolean => {
  return /^0x[a-fA-F0-9]{40}$/.test(address);
};

/**
 * Get explorer URL for transaction
 */
export const getExplorerUrl = (
  txHash: string,
  network: 'mainnet' | 'testnet' = 'testnet'
): string => {
  const baseUrl = network === 'mainnet'
    ? 'https://explorer.zksync.io'
    : 'https://sepolia.explorer.zksync.io';

  return `${baseUrl}/tx/${txHash}`;
};

/**
 * Get explorer URL for address
 */
export const getAddressExplorerUrl = (
  address: string,
  network: 'mainnet' | 'testnet' = 'testnet'
): string => {
  const baseUrl = network === 'mainnet'
    ? 'https://explorer.zksync.io'
    : 'https://sepolia.explorer.zksync.io';

  return `${baseUrl}/address/${address}`;
};

/**
 * Truncate text with ellipsis
 */
export const truncateText = (text: string, maxLength: number): string => {
  if (text.length <= maxLength) return text;
  return text.slice(0, maxLength) + '...';
};

/**
 * Copy to clipboard
 */
export const copyToClipboard = async (text: string): Promise<boolean> => {
  try {
    await navigator.clipboard.writeText(text);
    return true;
  } catch (err) {
    return false;
  }
};

/**
 * Generate random spell suggestion
 */
export const generateSpellSuggestion = (): string => {
  const mysticalWords = [
    'Abracadabra', 'Alakazam', 'Presto', 'Vanish', 'Evanesco',
    'Obliviate', 'Deletrius', 'Finite', 'Nullify', 'Banish',
    'Expunge', 'Erase', 'Obliterate', 'Annihilate', 'Dissolve'
  ];

  const numbers = Math.floor(Math.random() * 10000);
  const word1 = mysticalWords[Math.floor(Math.random() * mysticalWords.length)];
  const word2 = mysticalWords[Math.floor(Math.random() * mysticalWords.length)];

  return `${word1}${word2}${numbers}`;
};

/**
 * Validate spell strength
 */
export const validateSpellStrength = (spell: string): {
  isValid: boolean;
  strength: 'weak' | 'medium' | 'strong';
  feedback: string;
} => {
  if (spell.length < 8) {
    return {
      isValid: false,
      strength: 'weak',
      feedback: 'Spell must be at least 8 characters long'
    };
  }

  let score = 0;
  if (spell.length >= 12) score += 1;
  if (/[A-Z]/.test(spell)) score += 1;
  if (/[a-z]/.test(spell)) score += 1;
  if (/[0-9]/.test(spell)) score += 1;
  if (/[^A-Za-z0-9]/.test(spell)) score += 1;

  if (score < 3) {
    return {
      isValid: true,
      strength: 'weak',
      feedback: 'Add numbers or special characters for a stronger spell'
    };
  } else if (score < 5) {
    return {
      isValid: true,
      strength: 'medium',
      feedback: 'Good spell! Consider adding more variety for maximum security'
    };
  } else {
    return {
      isValid: true,
      strength: 'strong',
      feedback: 'Excellent spell! Your scroll is well protected'
    };
  }
};

/**
 * Format large numbers with K, M, B suffixes
 */
export const formatNumber = (num: number): string => {
  if (num >= 1_000_000_000) {
    return `${(num / 1_000_000_000).toFixed(1)}B`;
  }
  if (num >= 1_000_000) {
    return `${(num / 1_000_000).toFixed(1)}M`;
  }
  if (num >= 1_000) {
    return `${(num / 1_000).toFixed(1)}K`;
  }
  return num.toString();
};

/**
 * Debounce function to limit function calls
 */
export const debounce = <T extends (...args: any[]) => any>(
  func: T,
  wait: number
): ((...args: Parameters<T>) => void) => {
  let timeout: NodeJS.Timeout | null = null;

  return (...args: Parameters<T>) => {
    if (timeout) clearTimeout(timeout);
    timeout = setTimeout(() => func(...args), wait);
  };
};

/**
 * Sleep/delay function
 */
export const sleep = (ms: number): Promise<void> => {
  return new Promise((resolve) => setTimeout(resolve, ms));
};

/**
 * Retry async function with exponential backoff
 */
export const retryWithBackoff = async <T>(
  fn: () => Promise<T>,
  maxRetries: number = 3,
  baseDelay: number = 1000
): Promise<T> => {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      await sleep(baseDelay * Math.pow(2, i));
    }
  }
  throw new Error('Max retries exceeded');
};

/**
 * Check if string is valid JSON
 */
export const isValidJson = (str: string): boolean => {
  try {
    JSON.parse(str);
    return true;
  } catch {
    return false;
  }
};

/**
 * Convert Wei to ETH
 */
export const weiToEth = (wei: bigint | string): string => {
  const weiValue = typeof wei === 'string' ? BigInt(wei) : wei;
  return (Number(weiValue) / 1e18).toFixed(6);
};

/**
 * Convert ETH to Wei
 */
export const ethToWei = (eth: number | string): bigint => {
  const ethValue = typeof eth === 'string' ? parseFloat(eth) : eth;
  return BigInt(Math.floor(ethValue * 1e18));
};
