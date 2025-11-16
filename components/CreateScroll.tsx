'use client';

import { useState, useMemo } from 'react';
import { useAccount, useWalletClient } from 'wagmi';
import { ethers } from 'ethers';
import { Wand2, Sparkles, AlertCircle, ShieldCheck } from 'lucide-react';
import dynamic from 'next/dynamic';
import { uploadToIpfs } from '@/lib/ipfs';
import { getContract, generateSpellHash, CONTRACT_ADDRESS } from '@/lib/contract';
import 'easymde/dist/easymde.min.css';

const SimpleMDE = dynamic(() => import('react-simplemde-editor'), { ssr: false });

type SpellStrength = {
  score: number;
  label: 'Fragile' | 'Guarded' | 'Fortified' | 'Mythic';
  suggestions: string[];
};

const adjectives = [
  'Luminous',
  'Silent',
  'Astral',
  'Quantum',
  'Velvet',
  'Solar',
  'Glimmering',
  'Iron',
  'Opal',
  'Arcane',
];

const nouns = [
  'Phoenix',
  'Runes',
  'Cipher',
  'Nebula',
  'Obsidian',
  'Cascade',
  'Voyager',
  'Paradox',
  'Sentinel',
  'Equinox',
];

const symbols = ['*', '#', '@', '!', '?', '%', '&', '~'];

const secureRandomIndex = (max: number) => {
  if (typeof crypto !== 'undefined' && 'getRandomValues' in crypto) {
    const array = new Uint32Array(1);
    crypto.getRandomValues(array);
    return Number(array[0] % max);
  }
  return Math.floor(Math.random() * max);
};

const conjureSpellSuggestion = () => {
  const adjective = adjectives[secureRandomIndex(adjectives.length)];
  const noun = nouns[secureRandomIndex(nouns.length)];
  const symbol = symbols[secureRandomIndex(symbols.length)];
  const entropyNumbers = secureRandomIndex(9000) + 1000; // 4 digits between 1000-9999
  return `${adjective}-${noun}-${entropyNumbers}${symbol}`;
};

const evaluateSpellStrength = (spell: string): SpellStrength => {
  if (!spell) {
    return {
      score: 0,
      label: 'Fragile',
      suggestions: ['Use at least 8 characters with symbols, numbers, and mixed case.'],
    };
  }

  const lengthScore = Math.min(2, Math.floor(spell.length / 8));
  const diversityScore = [/[a-z]/, /[A-Z]/, /\d/, /[^A-Za-z0-9]/].reduce(
    (score, regex) => (regex.test(spell) ? score + 1 : score),
    0
  );

  const entropyScore = Math.max(0, Math.min(2, diversityScore - 1));
  const score = Math.min(3, lengthScore + entropyScore);

  const labels: SpellStrength['label'][] = ['Fragile', 'Guarded', 'Fortified', 'Mythic'];
  const suggestions: Record<SpellStrength['label'], string[]> = {
    Fragile: [
      'Lengthen the spell beyond 12 characters.',
      'Mix upper and lower case letters with numbers.',
      'Add symbols to resist brute force unraveling.',
    ],
    Guarded: [
      'Add more unique characters or a symbol.',
      'Consider a memorable passphrase instead of a single word.',
    ],
    Fortified: ['Great! Add one more unique element to reach mythic strength.'],
    Mythic: ['This spell is battle-tested. Keep it private!'],
  };

  return {
    score,
    label: labels[score],
    suggestions: suggestions[labels[score]],
  };
};

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
    ] as any,
  }), []);

  const spellStrength = useMemo(() => evaluateSpellStrength(secretSpell), [secretSpell]);

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

    if (spellStrength.score < 2) {
      setError('Strengthen your secret spell to at least Fortified before publishing.');
      return;
    }

    setIsPublishing(true);
    setError('');
    setSuccess('');

    try {
      // Step 1: Upload to IPFS
      const ipfsHash = await uploadToIpfs({
        title,
        content,
        author: address,
        timestamp: Date.now(),
      });

      // Step 2: Generate spell hash
      const spellHash = generateSpellHash(secretSpell);

      // Step 3: Publish to blockchain
      const provider = new ethers.BrowserProvider(walletClient as any);
      const signer = await provider.getSigner();
      const contract = getContract(signer);

      const tx = await contract.publishScroll(ipfsHash, spellHash, title);

      await tx.wait();

      setSuccess(`Scroll successfully inscribed! Transaction: ${tx.hash.slice(0, 10)}...`);

      // Reset form
      setTimeout(() => {
        setTitle('');
        setContent('');
        setSecretSpell('');
        setSuccess('');
      }, 5000);

    } catch (err: any) {
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
          <div className="flex items-center justify-between mt-3 text-sm text-ancient-parchment/80">
            <div className="flex items-center gap-2">
              <ShieldCheck className={`w-4 h-4 ${spellStrength.score >= 2 ? 'text-emerald-300' : 'text-amber-300'}`} />
              <span className="font-semibold">Spell strength: {spellStrength.label}</span>
            </div>
            <span>
              {(spellStrength.score / 3 * 100).toFixed(0)}% entropy
            </span>
          </div>
          <div className="w-full h-2 bg-purple-900/50 rounded-full overflow-hidden mt-2">
            <div
              className={`h-full transition-all duration-500 ${
                spellStrength.label === 'Fragile'
                  ? 'bg-red-400'
                  : spellStrength.label === 'Guarded'
                  ? 'bg-amber-300'
                  : spellStrength.label === 'Fortified'
                  ? 'bg-emerald-400'
                  : 'bg-cyan-300'
              }`}
              style={{ width: `${(spellStrength.score / 3) * 100}%` }}
            />
          </div>
          {spellStrength.suggestions.length > 0 && (
            <ul className="list-disc list-inside text-ancient-parchment/70 text-sm mt-2 space-y-1">
              {spellStrength.suggestions.map((tip) => (
                <li key={tip}>{tip}</li>
              ))}
            </ul>
          )}
          <div className="flex flex-wrap gap-2 mt-3">
            <button
              type="button"
              onClick={() => setSecretSpell(conjureSpellSuggestion())}
              className="px-3 py-2 rounded-md bg-purple-900/40 border border-spell-gold/30 text-ancient-parchment hover:bg-purple-900/60 transition-colors"
              disabled={isPublishing}
            >
              Conjure a strong spell
            </button>
            <button
              type="button"
              onClick={() => setSecretSpell(secretSpell + symbols[secureRandomIndex(symbols.length)])}
              className="px-3 py-2 rounded-md bg-purple-900/20 border border-spell-gold/20 text-ancient-parchment/80 hover:text-ancient-parchment"
              disabled={isPublishing}
            >
              Add another glyph
            </button>
          </div>
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
