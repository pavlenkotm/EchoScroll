'use client';

import { useState } from 'react';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import { Sparkles, BookOpen, Wand2 } from 'lucide-react';
import { useAccount } from 'wagmi';
import ScrollFeed from '@/components/ScrollFeed';
import CreateScroll from '@/components/CreateScroll';

export default function Home() {
  const [activeTab, setActiveTab] = useState<'feed' | 'create'>('feed');
  const { isConnected } = useAccount();

  return (
    <main className="min-h-screen">
      {/* Header */}
      <header className="border-b border-spell-gold/20 backdrop-blur-sm bg-mystic-blue/30 sticky top-0 z-50">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Sparkles className="w-8 h-8 text-spell-gold animate-pulse" />
            <h1 className="text-3xl font-serif text-spell-gold font-bold tracking-wide">
              EchoScroll
            </h1>
          </div>
          <ConnectButton />
        </div>
      </header>

      {/* Hero Section */}
      <section className="container mx-auto px-4 py-12 text-center">
        <div className="max-w-3xl mx-auto">
          <h2 className="text-5xl font-serif text-ancient-parchment mb-4 animate-float">
            The Eternal Blockchain Library
          </h2>
          <p className="text-xl text-ancient-parchment/80 mb-8">
            Inscribe your thoughts into the immutable ledger. Only your secret spell can vanish them from the chain.
          </p>

          {!isConnected && (
            <div className="flex items-center justify-center gap-2 text-spell-gold">
              <Wand2 className="w-5 h-5" />
              <p className="text-lg">Connect your wallet to begin your magical journey</p>
            </div>
          )}
        </div>
      </section>

      {/* Main Content */}
      {isConnected && (
        <section className="container mx-auto px-4 py-8">
          {/* Tabs */}
          <div className="flex gap-4 mb-8 justify-center">
            <button
              onClick={() => setActiveTab('feed')}
              className={`flex items-center gap-2 px-6 py-3 rounded-lg font-semibold transition-all ${
                activeTab === 'feed'
                  ? 'bg-spell-gold text-mystic-blue magic-glow'
                  : 'bg-purple-900/30 text-ancient-parchment hover:bg-purple-900/50'
              }`}
            >
              <BookOpen className="w-5 h-5" />
              Scroll Library
            </button>
            <button
              onClick={() => setActiveTab('create')}
              className={`flex items-center gap-2 px-6 py-3 rounded-lg font-semibold transition-all ${
                activeTab === 'create'
                  ? 'bg-spell-gold text-mystic-blue magic-glow'
                  : 'bg-purple-900/30 text-ancient-parchment hover:bg-purple-900/50'
              }`}
            >
              <Wand2 className="w-5 h-5" />
              Inscribe Scroll
            </button>
          </div>

          {/* Content */}
          <div className="max-w-5xl mx-auto">
            {activeTab === 'feed' ? <ScrollFeed /> : <CreateScroll />}
          </div>
        </section>
      )}

      {/* Footer */}
      <footer className="container mx-auto px-4 py-8 text-center text-ancient-parchment/60 border-t border-spell-gold/20 mt-12">
        <p className="flex items-center justify-center gap-2">
          <Sparkles className="w-4 h-4" />
          Powered by zkSync Era & IPFS
          <Sparkles className="w-4 h-4" />
        </p>
      </footer>
    </main>
  );
}
