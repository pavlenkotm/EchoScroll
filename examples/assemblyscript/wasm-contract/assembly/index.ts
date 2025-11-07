// AssemblyScript NEAR Smart Contract Example

import { context, storage, logging, PersistentMap } from "near-sdk-as";

// Storage key constants
const MESSAGE_COUNT_KEY = "message_count";

// Message class
@nearBindgen
export class Message {
  id: u64;
  author: string;
  text: string;
  timestamp: u64;

  constructor(id: u64, author: string, text: string) {
    this.id = id;
    this.author = author;
    this.text = text;
    this.timestamp = context.blockTimestamp;
  }
}

// Persistent storage for messages
const messages = new PersistentMap<u64, Message>("m");

/**
 * Add a new message to the guestbook
 * @param text - Message content
 * @returns Message ID
 */
export function addMessage(text: string): u64 {
  assert(text.length > 0, "Message cannot be empty");
  assert(text.length <= 500, "Message too long (max 500 characters)");

  const messageCount = getMessageCount();
  const messageId = messageCount;

  const message = new Message(
    messageId,
    context.sender,
    text
  );

  messages.set(messageId, message);
  storage.set(MESSAGE_COUNT_KEY, messageCount + 1);

  logging.log(`Message added by ${context.sender}: "${text}"`);

  return messageId;
}

/**
 * Get a message by ID
 * @param id - Message ID
 * @returns Message or null
 */
export function getMessage(id: u64): Message | null {
  return messages.get(id);
}

/**
 * Get total number of messages
 * @returns Message count
 */
export function getMessageCount(): u64 {
  return storage.getPrimitive<u64>(MESSAGE_COUNT_KEY, 0);
}

/**
 * Get recent messages
 * @param limit - Maximum number of messages to return
 * @returns Array of messages
 */
export function getRecentMessages(limit: u64): Message[] {
  const count = getMessageCount();
  const start = count > limit ? count - limit : 0;

  const result: Message[] = [];

  for (let i = start; i < count; i++) {
    const message = messages.get(i);
    if (message) {
      result.push(message);
    }
  }

  return result;
}

/**
 * Get all messages by a specific author
 * @param author - Author's account ID
 * @returns Array of messages
 */
export function getMessagesByAuthor(author: string): Message[] {
  const count = getMessageCount();
  const result: Message[] = [];

  for (let i: u64 = 0; i < count; i++) {
    const message = messages.get(i);
    if (message && message.author === author) {
      result.push(message);
    }
  }

  return result;
}

/**
 * Check if a user has posted any messages
 * @param author - Author's account ID
 * @returns True if user has posted
 */
export function hasPosted(author: string): bool {
  const count = getMessageCount();

  for (let i: u64 = 0; i < count; i++) {
    const message = messages.get(i);
    if (message && message.author === author) {
      return true;
    }
  }

  return false;
}

/**
 * Get contract information
 * @returns Contract info
 */
export function getInfo(): string {
  return `
    Guestbook Contract
    Messages: ${getMessageCount()}
    Network: ${context.networkId}
  `;
}
