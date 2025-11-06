export interface Scroll {
  id: bigint;
  author: string;
  ipfsHash: string;
  timestamp: bigint;
  title: string;
  exists: boolean;
}

export interface ScrollContent {
  title: string;
  content: string;
  author: string;
  timestamp: number;
}

export interface ScrollEvent {
  id: bigint;
  author: string;
  ipfsHash?: string;
  title?: string;
  timestamp: bigint;
}

export interface SpellCastEvent {
  id: bigint;
  caster: string;
  success: boolean;
}
