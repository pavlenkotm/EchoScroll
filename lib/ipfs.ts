import type { IPFSHTTPClient } from 'ipfs-http-client';

let ipfsClient: IPFSHTTPClient | null = null;

export const getIpfsClient = async (): Promise<IPFSHTTPClient> => {
  if (typeof window === 'undefined') {
    throw new Error('IPFS client can only be initialized on the client side');
  }

  if (!ipfsClient) {
    // Dynamic import to avoid SSR issues
    const { create } = await import('ipfs-http-client');

    const projectId = process.env.NEXT_PUBLIC_IPFS_PROJECT_ID;
    const projectSecret = process.env.NEXT_PUBLIC_IPFS_PROJECT_SECRET;

    if (projectId && projectSecret) {
      const auth = 'Basic ' + btoa(projectId + ':' + projectSecret);

      ipfsClient = create({
        url: process.env.NEXT_PUBLIC_IPFS_API_URL || 'https://ipfs.infura.io:5001',
        headers: {
          authorization: auth,
        },
      });
    } else {
      // Fallback to local IPFS node or public gateway
      ipfsClient = create({
        url: process.env.NEXT_PUBLIC_IPFS_API_URL || 'https://ipfs.infura.io:5001'
      });
    }
  }

  return ipfsClient;
};

export interface ScrollContent {
  title: string;
  content: string;
  author: string;
  timestamp: number;
}

/**
 * Upload scroll content to IPFS
 * @param content - The scroll content to upload
 * @returns The IPFS hash (CID)
 * @throws Error if upload fails
 */
export const uploadToIpfs = async (content: ScrollContent): Promise<string> => {
  try {
    const client = await getIpfsClient();
    const contentString = JSON.stringify(content);
    const result = await client.add(contentString);
    return result.path; // Returns IPFS hash
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    console.error('IPFS upload failed:', message);
    throw new Error(`Failed to upload content to IPFS: ${message}`);
  }
};

/**
 * Retrieve scroll content from IPFS
 * @param hash - The IPFS hash (CID) to fetch
 * @param timeout - Optional timeout in milliseconds (default: 30000)
 * @returns The scroll content
 * @throws Error if fetch fails or times out
 */
export const fetchFromIpfs = async (hash: string, timeout: number = 30000): Promise<ScrollContent> => {
  try {
    const gateway = process.env.NEXT_PUBLIC_IPFS_GATEWAY || 'https://ipfs.io/ipfs/';
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), timeout);

    const response = await fetch(`${gateway}${hash}`, {
      signal: controller.signal,
    });

    clearTimeout(timeoutId);

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }

    const content = await response.json();

    // Validate content structure
    if (!content.title || !content.content || !content.author) {
      throw new Error('Invalid scroll content structure');
    }

    return content as ScrollContent;
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    console.error('IPFS fetch failed:', message);
    throw new Error(`Failed to retrieve content from IPFS: ${message}`);
  }
};

/**
 * Get IPFS gateway URL for a hash
 * @param hash - The IPFS hash (CID)
 * @returns The full gateway URL
 */
export const getIpfsUrl = (hash: string): string => {
  const gateway = process.env.NEXT_PUBLIC_IPFS_GATEWAY || 'https://ipfs.io/ipfs/';
  return `${gateway}${hash}`;
};

/**
 * Validate IPFS hash format (basic validation)
 * @param hash - The hash to validate
 * @returns True if hash appears to be valid
 */
export const isValidIpfsHash = (hash: string): boolean => {
  // Check for CIDv0 (Qm...) or CIDv1 (b...)
  return /^Qm[1-9A-HJ-NP-Za-km-z]{44}$/.test(hash) || /^b[a-z2-7]{58}$/.test(hash);
};

/**
 * Pin content to IPFS (if using a service that supports pinning)
 * @param hash - The IPFS hash to pin
 * @returns Success status
 */
export const pinToIpfs = async (hash: string): Promise<boolean> => {
  try {
    const client = await getIpfsClient();
    await client.pin.add(hash);
    return true;
  } catch (error) {
    console.error('IPFS pinning failed:', error);
    return false;
  }
};
