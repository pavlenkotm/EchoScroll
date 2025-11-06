'use client';

import { useState, useEffect } from 'react';
import { useWalletClient } from 'wagmi';
import { ethers } from 'ethers';
import { motion, AnimatePresence } from 'framer-motion';
import { User, Calendar, Trash2, Sparkles, AlertCircle, ExternalLink } from 'lucide-react';
import ReactMarkdown from 'react-markdown';
import { fetchFromIpfs, ScrollContent } from '@/lib/ipfs';
import { getContract } from '@/lib/contract';

interface ScrollCardProps {
  scroll: {
    id: bigint;
    author: string;
    ipfsHash: string;
    timestamp: bigint;
    title: string;
  };
  currentUser?: string;
  onDeleted?: () => void;
}

export default function ScrollCard({ scroll, currentUser, onDeleted }: ScrollCardProps) {
  const [content, setContent] = useState<ScrollContent | null>(null);
  const [loadingContent, setLoadingContent] = useState(true);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [deletionSpell, setDeletionSpell] = useState('');
  const [isDeleting, setIsDeleting] = useState(false);
  const [deleteError, setDeleteError] = useState('');
  const [isVanishing, setIsVanishing] = useState(false);

  const { data: walletClient } = useWalletClient();

  const isAuthor = currentUser?.toLowerCase() === scroll.author.toLowerCase();

  useEffect(() => {
    const loadContent = async () => {
      try {
        const scrollContent = await fetchFromIpfs(scroll.ipfsHash);
        setContent(scrollContent);
      } catch (err) {
        console.error('Error loading content from IPFS:', err);
      } finally {
        setLoadingContent(false);
      }
    };

    loadContent();
  }, [scroll.ipfsHash]);

  const handleDeleteClick = () => {
    setShowDeleteModal(true);
    setDeleteError('');
    setDeletionSpell('');
  };

  const handleCastSpell = async () => {
    if (!deletionSpell.trim()) {
      setDeleteError('You must speak the spell!');
      return;
    }

    if (!walletClient) {
      setDeleteError('Please connect your wallet');
      return;
    }

    setIsDeleting(true);
    setDeleteError('');

    try {
      const provider = new ethers.BrowserProvider(walletClient as any);
      const signer = await provider.getSigner();
      const contract = getContract(signer);

      console.log('🔮 Casting deletion spell for scroll', scroll.id.toString());

      const tx = await contract.castDeletionSpell(scroll.id, deletionSpell);
      console.log('📝 Transaction sent:', tx.hash);

      await tx.wait();
      console.log('✨ Scroll deleted successfully!');

      // Start vanishing animation
      setIsVanishing(true);
      setShowDeleteModal(false);

      // Wait for animation to complete, then notify parent
      setTimeout(() => {
        onDeleted?.();
      }, 1000);

    } catch (err: any) {
      console.error('Error casting deletion spell:', err);

      if (err.message?.includes('spell was incorrectly cast')) {
        setDeleteError('The spell was incorrectly cast! Check your secret phrase.');
      } else if (err.message?.includes('user rejected')) {
        setDeleteError('Transaction was cancelled');
      } else {
        setDeleteError(err.message || 'Failed to cast spell. Please try again.');
      }
    } finally {
      setIsDeleting(false);
    }
  };

  const formatDate = (timestamp: bigint) => {
    return new Date(Number(timestamp) * 1000).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  const shortenAddress = (address: string) => {
    return `${address.slice(0, 6)}...${address.slice(-4)}`;
  };

  return (
    <AnimatePresence>
      {!isVanishing && (
        <motion.div
          initial={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 0, rotate: 10 }}
          transition={{ duration: 1 }}
          className="scroll-card"
        >
          {/* Header */}
          <div className="flex items-start justify-between mb-4">
            <div className="flex-1">
              <h3 className="text-2xl font-serif text-spell-gold mb-2">
                {scroll.title}
              </h3>
              <div className="flex flex-wrap gap-4 text-sm text-ancient-parchment/70">
                <div className="flex items-center gap-1">
                  <User className="w-4 h-4" />
                  <span title={scroll.author}>{shortenAddress(scroll.author)}</span>
                </div>
                <div className="flex items-center gap-1">
                  <Calendar className="w-4 h-4" />
                  <span>{formatDate(scroll.timestamp)}</span>
                </div>
                <a
                  href={`https://sepolia.explorer.zksync.io/tx/${scroll.id}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center gap-1 text-spell-gold hover:underline"
                >
                  <ExternalLink className="w-4 h-4" />
                  View on Explorer
                </a>
              </div>
            </div>

            {isAuthor && (
              <button
                onClick={handleDeleteClick}
                className="ml-4 p-2 bg-red-500/20 hover:bg-red-500/30 border border-red-500/50 rounded-lg transition-colors"
                title="Cast deletion spell"
              >
                <Trash2 className="w-5 h-5 text-red-300" />
              </button>
            )}
          </div>

          {/* Content */}
          <div className="border-t border-spell-gold/20 pt-4">
            {loadingContent ? (
              <div className="text-ancient-parchment/60 text-center py-8">
                Loading scroll content from IPFS...
              </div>
            ) : content ? (
              <div className="markdown-preview text-ancient-parchment/90">
                <ReactMarkdown>{content.content}</ReactMarkdown>
              </div>
            ) : (
              <div className="text-red-300 text-center py-8">
                Failed to load content from IPFS
              </div>
            )}
          </div>

          {/* Deletion Modal */}
          <AnimatePresence>
            {showDeleteModal && (
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="fixed inset-0 bg-black/80 backdrop-blur-sm flex items-center justify-center z-50 p-4"
                onClick={() => setShowDeleteModal(false)}
              >
                <motion.div
                  initial={{ scale: 0.9, opacity: 0 }}
                  animate={{ scale: 1, opacity: 1 }}
                  exit={{ scale: 0.9, opacity: 0 }}
                  className="bg-gradient-to-br from-mystic-blue to-mystic-purple border-2 border-spell-gold rounded-lg p-8 max-w-md w-full magic-glow"
                  onClick={(e) => e.stopPropagation()}
                >
                  <h3 className="text-2xl font-serif text-spell-gold mb-4 flex items-center gap-2">
                    <Sparkles className="w-6 h-6" />
                    Cast Deletion Spell
                  </h3>

                  <p className="text-ancient-parchment/80 mb-6">
                    Speak your secret spell to vanish this scroll from the eternal library.
                    This action cannot be undone.
                  </p>

                  <input
                    type="password"
                    value={deletionSpell}
                    onChange={(e) => setDeletionSpell(e.target.value)}
                    placeholder="Enter your secret spell..."
                    className="w-full spell-input mb-4"
                    disabled={isDeleting}
                    onKeyPress={(e) => e.key === 'Enter' && handleCastSpell()}
                  />

                  {deleteError && (
                    <div className="mb-4 p-3 bg-red-500/20 border border-red-500/50 rounded flex items-center gap-2 text-red-200 text-sm">
                      <AlertCircle className="w-4 h-4" />
                      {deleteError}
                    </div>
                  )}

                  <div className="flex gap-3">
                    <button
                      onClick={handleCastSpell}
                      disabled={isDeleting || !deletionSpell.trim()}
                      className="flex-1 bg-gradient-to-r from-red-600 to-red-500 text-white font-semibold py-3 px-4 rounded-lg hover:scale-105 active:scale-95 transition-all duration-200 shadow-lg disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
                    >
                      {isDeleting ? (
                        <>
                          <Sparkles className="w-5 h-5 animate-spin" />
                          Casting...
                        </>
                      ) : (
                        <>
                          <Trash2 className="w-5 h-5" />
                          Cast Spell
                        </>
                      )}
                    </button>
                    <button
                      onClick={() => setShowDeleteModal(false)}
                      disabled={isDeleting}
                      className="px-6 py-3 bg-purple-900/50 text-ancient-parchment rounded-lg hover:bg-purple-900/70 transition-colors disabled:opacity-50"
                    >
                      Cancel
                    </button>
                  </div>
                </motion.div>
              </motion.div>
            )}
          </AnimatePresence>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
