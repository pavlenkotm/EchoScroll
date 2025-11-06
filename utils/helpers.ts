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
    console.error('Failed to copy:', err);
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
