'use client';

import { useState, useMemo } from 'react';
import { useAccount, useWalletClient } from 'wagmi';
import { ethers } from 'ethers';
import { Wand2, Sparkles, AlertCircle } from 'lucide-react';
import dynamic from 'next/dynamic';
import { uploadToIpfs } from '@/lib/ipfs';
import { getContract, generateSpellHash, CONTRACT_ADDRESS } from '@/lib/contract';
import 'easymde/dist/easymde.min.css';

const SimpleMDE = dynamic(() => import('react-simplemde-editor'), { ssr: false });

export default function CreateScroll() {
  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');
  const [secretSpell, setSecretSpell] = useState('');
  const [isPublishing, setIsPublishing] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const { address } = useAccount();
  const { data: walletClient } = useWalletClient();

  const editorOptions = useMemo(() => ({
    spellChecker: false,
    placeholder: 'Inscribe your eternal wisdom here...',
    status: false,
    toolbar: [
      'bold', 'italic', 'heading', '|',
      'quote', 'unordered-list', 'ordered-list', '|',
      'link', 'image', '|',
      'preview', 'side-by-side', 'fullscreen'
    ],
  }), []);

  const handlePublish = async () => {
    if (!title.trim() || !content.trim() || !secretSpell.trim()) {
      setError('All fields are required, including your secret deletion spell!');
      return;
    }

    if (!address || !walletClient) {
      setError('Please connect your wallet first');
      return;
    }

    if (secretSpell.length < 8) {
      setError('Your spell must be at least 8 characters long for proper protection');
      return;
    }

    setIsPublishing(true);
    setError('');
    setSuccess('');

    try {
      // Step 1: Upload to IPFS
      console.log('📜 Uploading scroll to IPFS...');
      const ipfsHash = await uploadToIpfs({
        title,
        content,
        author: address,
        timestamp: Date.now(),
      });

      console.log('✅ IPFS hash:', ipfsHash);

      // Step 2: Generate spell hash
      const spellHash = generateSpellHash(secretSpell);
      console.log('🔮 Spell hash generated');

      // Step 3: Publish to blockchain
      console.log('⛓️ Publishing to blockchain...');

      const provider = new ethers.BrowserProvider(walletClient as any);
      const signer = await provider.getSigner();
      const contract = getContract(signer);

      const tx = await contract.publishScroll(ipfsHash, spellHash, title);
      console.log('📝 Transaction sent:', tx.hash);

      const receipt = await tx.wait();
      console.log('✨ Scroll published! Receipt:', receipt);

      setSuccess(`Scroll successfully inscribed! Transaction: ${tx.hash.slice(0, 10)}...`);

      // Reset form
      setTimeout(() => {
        setTitle('');
        setContent('');
        setSecretSpell('');
        setSuccess('');
      }, 5000);

    } catch (err: any) {
      console.error('Error publishing scroll:', err);
      setError(err.message || 'Failed to publish scroll. Please try again.');
    } finally {
      setIsPublishing(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="scroll-card">
        <h3 className="text-2xl font-serif text-spell-gold mb-6 flex items-center gap-2">
          <Wand2 className="w-6 h-6" />
          Inscribe a New Scroll
        </h3>

        {/* Title Input */}
        <div className="mb-4">
          <label className="block text-ancient-parchment mb-2 font-semibold">
            Scroll Title
          </label>
          <input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="The Chronicles of..."
            className="w-full spell-input"
            disabled={isPublishing}
          />
        </div>

        {/* Content Editor */}
        <div className="mb-4">
          <label className="block text-ancient-parchment mb-2 font-semibold">
            Scroll Content
          </label>
          <SimpleMDE
            value={content}
            onChange={setContent}
            options={editorOptions}
          />
        </div>

        {/* Secret Spell Input */}
        <div className="mb-6">
          <label className="block text-ancient-parchment mb-2 font-semibold flex items-center gap-2">
            <Sparkles className="w-4 h-4 text-spell-gold" />
            Secret Deletion Spell
          </label>
          <input
            type="password"
            value={secretSpell}
            onChange={(e) => setSecretSpell(e.target.value)}
            placeholder="Only you will know this spell..."
            className="w-full spell-input"
            disabled={isPublishing}
          />
          <p className="text-ancient-parchment/60 text-sm mt-2">
            This spell is required to delete your scroll. Keep it safe and secret! (min. 8 characters)
          </p>
        </div>

        {/* Error/Success Messages */}
        {error && (
          <div className="mb-4 p-4 bg-red-500/20 border border-red-500/50 rounded-lg flex items-center gap-2 text-red-200">
            <AlertCircle className="w-5 h-5" />
            {error}
          </div>
        )}

        {success && (
          <div className="mb-4 p-4 bg-green-500/20 border border-green-500/50 rounded-lg flex items-center gap-2 text-green-200">
            <Sparkles className="w-5 h-5" />
            {success}
          </div>
        )}

        {/* Publish Button */}
        <button
          onClick={handlePublish}
          disabled={isPublishing || !title || !content || !secretSpell}
          className="magic-button w-full disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
        >
          {isPublishing ? (
            <>
              <Sparkles className="w-5 h-5 animate-spin" />
              Inscribing to the Eternal Library...
            </>
          ) : (
            <>
              <Wand2 className="w-5 h-5" />
              Publish Scroll to Blockchain
            </>
          )}
        </button>

        {/* Info */}
        <div className="mt-4 p-4 bg-purple-900/30 rounded-lg border border-spell-gold/20">
          <p className="text-ancient-parchment/80 text-sm">
            Your scroll will be stored on IPFS and inscribed on zkSync Era blockchain.
            The secret spell you provide will be hashed and stored on-chain for future deletion verification.
          </p>
        </div>
      </div>
    </div>
  );
}
