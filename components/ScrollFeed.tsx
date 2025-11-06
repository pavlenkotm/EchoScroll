'use client';

import { useState, useEffect } from 'react';
import { useAccount, usePublicClient } from 'wagmi';
import { ethers } from 'ethers';
import { BookOpen, Loader2 } from 'lucide-react';
import { getContract, CONTRACT_ADDRESS } from '@/lib/contract';
import ScrollCard from './ScrollCard';

interface Scroll {
  id: bigint;
  author: string;
  ipfsHash: string;
  timestamp: bigint;
  title: string;
}

export default function ScrollFeed() {
  const [scrolls, setScrolls] = useState<Scroll[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const { address } = useAccount();
  const publicClient = usePublicClient();

  const loadScrolls = async () => {
    try {
      setLoading(true);
      setError('');

      if (!publicClient) {
        throw new Error('No provider available');
      }

      const provider = new ethers.JsonRpcProvider(
        publicClient.transport.url || 'https://sepolia.era.zksync.dev'
      );

      const contract = getContract(provider);

      // Get all active scroll IDs
      const activeScrollIds = await contract.getActiveScrolls();
      console.log('Active scrolls:', activeScrollIds);

      // Fetch details for each scroll
      const scrollDetails = await Promise.all(
        activeScrollIds.map(async (id: bigint) => {
          try {
            const [scrollId, author, ipfsHash, timestamp, title] = await contract.getScroll(id);
            return {
              id: scrollId,
              author,
              ipfsHash,
              timestamp,
              title,
            };
          } catch (err) {
            console.error(`Error fetching scroll ${id}:`, err);
            return null;
          }
        })
      );

      // Filter out any null results and sort by timestamp (newest first)
      const validScrolls = scrollDetails
        .filter((scroll): scroll is Scroll => scroll !== null)
        .sort((a, b) => Number(b.timestamp) - Number(a.timestamp));

      setScrolls(validScrolls);
    } catch (err: any) {
      console.error('Error loading scrolls:', err);
      setError('Failed to load scrolls from the blockchain');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadScrolls();
  }, [publicClient]);

  const handleScrollDeleted = () => {
    // Reload scrolls when one is deleted
    loadScrolls();
  };

  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center py-20">
        <Loader2 className="w-12 h-12 text-spell-gold animate-spin mb-4" />
        <p className="text-ancient-parchment/80">Loading scrolls from the eternal library...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="scroll-card text-center py-12">
        <p className="text-red-300">{error}</p>
        <button
          onClick={loadScrolls}
          className="mt-4 magic-button"
        >
          Try Again
        </button>
      </div>
    );
  }

  if (scrolls.length === 0) {
    return (
      <div className="scroll-card text-center py-20">
        <BookOpen className="w-16 h-16 text-spell-gold mx-auto mb-4 opacity-50" />
        <h3 className="text-2xl font-serif text-ancient-parchment mb-2">
          The Library Awaits
        </h3>
        <p className="text-ancient-parchment/60">
          No scrolls have been inscribed yet. Be the first to add your wisdom to the eternal library!
        </p>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between mb-6">
        <h3 className="text-2xl font-serif text-spell-gold flex items-center gap-2">
          <BookOpen className="w-6 h-6" />
          Eternal Library ({scrolls.length} scrolls)
        </h3>
        <button
          onClick={loadScrolls}
          className="text-ancient-parchment/60 hover:text-ancient-parchment transition-colors"
        >
          Refresh
        </button>
      </div>

      <div className="space-y-6">
        {scrolls.map((scroll) => (
          <ScrollCard
            key={scroll.id.toString()}
            scroll={scroll}
            currentUser={address}
            onDeleted={handleScrollDeleted}
          />
        ))}
      </div>
    </div>
  );
}
