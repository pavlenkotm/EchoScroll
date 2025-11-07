use near_sdk::borsh::{self, BorshDeserialize, BorshSerialize};
use near_sdk::collections::LookupMap;
use near_sdk::{env, near_bindgen, AccountId, Balance, Promise};
use near_sdk::serde::{Deserialize, Serialize};

#[near_bindgen]
#[derive(BorshDeserialize, BorshSerialize)]
pub struct GuestBook {
    messages: LookupMap<u64, Message>,
    message_count: u64,
}

#[derive(BorshDeserialize, BorshSerialize, Serialize, Deserialize, Clone)]
#[serde(crate = "near_sdk::serde")]
pub struct Message {
    pub id: u64,
    pub author: AccountId,
    pub text: String,
    pub timestamp: u64,
    pub donation: Balance,
}

impl Default for GuestBook {
    fn default() -> Self {
        Self {
            messages: LookupMap::new(b"m"),
            message_count: 0,
        }
    }
}

#[near_bindgen]
impl GuestBook {
    /// Initialize the contract
    #[init]
    pub fn new() -> Self {
        assert!(!env::state_exists(), "Already initialized");
        Self {
            messages: LookupMap::new(b"m"),
            message_count: 0,
        }
    }

    /// Add a new message to the guestbook
    /// Optionally attach NEAR tokens as a donation
    #[payable]
    pub fn add_message(&mut self, text: String) -> u64 {
        assert!(text.len() <= 500, "Message too long (max 500 characters)");
        assert!(!text.is_empty(), "Message cannot be empty");

        let donation = env::attached_deposit();
        let message = Message {
            id: self.message_count,
            author: env::predecessor_account_id(),
            text,
            timestamp: env::block_timestamp(),
            donation,
        };

        self.messages.insert(&self.message_count, &message);
        self.message_count += 1;

        env::log_str(&format!(
            "Message added by {} with donation: {} yoctoNEAR",
            message.author, donation
        ));

        message.id
    }

    /// Get a message by ID
    pub fn get_message(&self, id: u64) -> Option<Message> {
        self.messages.get(&id)
    }

    /// Get the total number of messages
    pub fn get_message_count(&self) -> u64 {
        self.message_count
    }

    /// Get recent messages (last N messages)
    pub fn get_recent_messages(&self, limit: u64) -> Vec<Message> {
        let start = if self.message_count > limit {
            self.message_count - limit
        } else {
            0
        };

        (start..self.message_count)
            .filter_map(|i| self.messages.get(&i))
            .collect()
    }

    /// Get all messages by a specific author
    pub fn get_messages_by_author(&self, author: AccountId) -> Vec<Message> {
        (0..self.message_count)
            .filter_map(|i| {
                let msg = self.messages.get(&i)?;
                if msg.author == author {
                    Some(msg)
                } else {
                    None
                }
            })
            .collect()
    }

    /// Tip a message author
    #[payable]
    pub fn tip_message(&mut self, message_id: u64) -> Promise {
        let message = self.messages.get(&message_id).expect("Message not found");
        let tip_amount = env::attached_deposit();

        assert!(tip_amount > 0, "Tip amount must be greater than 0");

        env::log_str(&format!(
            "Tipping {} to message #{} by {}",
            tip_amount, message_id, message.author
        ));

        Promise::new(message.author).transfer(tip_amount)
    }

    /// Get total donations across all messages
    pub fn get_total_donations(&self) -> Balance {
        (0..self.message_count)
            .filter_map(|i| self.messages.get(&i))
            .map(|msg| msg.donation)
            .sum()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use near_sdk::test_utils::{accounts, VMContextBuilder};
    use near_sdk::{testing_env, VMContext};

    fn get_context(predecessor: AccountId) -> VMContext {
        VMContextBuilder::new()
            .predecessor_account_id(predecessor)
            .build()
    }

    #[test]
    fn test_add_message() {
        let context = get_context(accounts(0));
        testing_env!(context);

        let mut contract = GuestBook::new();
        let id = contract.add_message("Hello NEAR!".to_string());

        assert_eq!(id, 0);
        assert_eq!(contract.get_message_count(), 1);

        let message = contract.get_message(id).unwrap();
        assert_eq!(message.text, "Hello NEAR!");
        assert_eq!(message.author, accounts(0));
    }

    #[test]
    #[should_panic(expected = "Message cannot be empty")]
    fn test_empty_message() {
        let context = get_context(accounts(0));
        testing_env!(context);

        let mut contract = GuestBook::new();
        contract.add_message("".to_string());
    }

    #[test]
    #[should_panic(expected = "Message too long")]
    fn test_message_too_long() {
        let context = get_context(accounts(0));
        testing_env!(context);

        let mut contract = GuestBook::new();
        contract.add_message("a".repeat(501));
    }

    #[test]
    fn test_multiple_messages() {
        let context = get_context(accounts(0));
        testing_env!(context);

        let mut contract = GuestBook::new();
        contract.add_message("Message 1".to_string());
        contract.add_message("Message 2".to_string());
        contract.add_message("Message 3".to_string());

        assert_eq!(contract.get_message_count(), 3);

        let recent = contract.get_recent_messages(2);
        assert_eq!(recent.len(), 2);
        assert_eq!(recent[0].text, "Message 2");
        assert_eq!(recent[1].text, "Message 3");
    }
}
