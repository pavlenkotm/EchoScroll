import { create, IPFSHTTPClient } from 'ipfs-http-client';

let ipfsClient: IPFSHTTPClient | null = null;

export const getIpfsClient = (): IPFSHTTPClient => {
  if (!ipfsClient) {
    const projectId = process.env.NEXT_PUBLIC_IPFS_PROJECT_ID || process.env.IPFS_PROJECT_ID;
    const projectSecret = process.env.NEXT_PUBLIC_IPFS_PROJECT_SECRET || process.env.IPFS_PROJECT_SECRET;

    if (projectId && projectSecret) {
      const auth = 'Basic ' + Buffer.from(projectId + ':' + projectSecret).toString('base64');

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
 */
export const uploadToIpfs = async (content: ScrollContent): Promise<string> => {
  try {
    const client = getIpfsClient();
    const contentString = JSON.stringify(content);
    const result = await client.add(contentString);
    return result.path; // Returns IPFS hash
  } catch (error) {
    throw new Error('Failed to upload content to IPFS');
  }
};

/**
 * Retrieve scroll content from IPFS
 */
export const fetchFromIpfs = async (hash: string): Promise<ScrollContent> => {
  try {
    const gateway = process.env.NEXT_PUBLIC_IPFS_GATEWAY || 'https://ipfs.io/ipfs/';
    const response = await fetch(`${gateway}${hash}`);

    if (!response.ok) {
      throw new Error('Failed to fetch from IPFS');
    }

    const content = await response.json();
    return content as ScrollContent;
  } catch (error) {
    throw new Error('Failed to retrieve content from IPFS');
  }
};

/**
 * Get IPFS gateway URL for a hash
 */
export const getIpfsUrl = (hash: string): string => {
  const gateway = process.env.NEXT_PUBLIC_IPFS_GATEWAY || 'https://ipfs.io/ipfs/';
  return `${gateway}${hash}`;
};
