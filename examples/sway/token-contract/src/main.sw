contract;

// Sway Token Contract for Fuel Network
// A modern, gas-efficient token implementation leveraging Fuel's UTXO model

use std::{
    auth::msg_sender,
    call_frames::msg_asset_id,
    context::msg_amount,
    hash::Hash,
    storage::storage_vec::*,
    token::*,
};

abi Token {
    #[storage(read, write)]
    fn initialize(supply: u64, name: str[32], symbol: str[8]);

    #[storage(read)]
    fn name() -> str[32];

    #[storage(read)]
    fn symbol() -> str[8];

    #[storage(read)]
    fn decimals() -> u8;

    #[storage(read)]
    fn total_supply() -> u64;

    #[storage(read)]
    fn balance_of(address: Identity) -> u64;

    #[storage(read, write)]
    fn transfer(recipient: Identity, amount: u64);

    #[storage(read, write)]
    fn mint(amount: u64, recipient: Identity);

    #[storage(read, write)]
    fn burn(amount: u64);
}

storage {
    name: str[32] = __to_str_array("FuelToken"),
    symbol: str[8] = __to_str_array("FUEL"),
    decimals: u8 = 9,
    total_supply: u64 = 0,
    balances: StorageMap<Identity, u64> = StorageMap {},
    initialized: bool = false,
}

impl Token for Contract {
    #[storage(read, write)]
    fn initialize(supply: u64, name: str[32], symbol: str[8]) {
        require(!storage.initialized.read(), "Already initialized");

        let sender = msg_sender().unwrap();

        storage.name.write(name);
        storage.symbol.write(symbol);
        storage.total_supply.write(supply);
        storage.balances.insert(sender, supply);
        storage.initialized.write(true);

        log(TransferEvent {
            from: ZERO_B256,
            to: sender,
            amount: supply,
        });
    }

    #[storage(read)]
    fn name() -> str[32] {
        storage.name.read()
    }

    #[storage(read)]
    fn symbol() -> str[8] {
        storage.symbol.read()
    }

    #[storage(read)]
    fn decimals() -> u8 {
        storage.decimals.read()
    }

    #[storage(read)]
    fn total_supply() -> u64 {
        storage.total_supply.read()
    }

    #[storage(read)]
    fn balance_of(address: Identity) -> u64 {
        storage.balances.get(address).try_read().unwrap_or(0)
    }

    #[storage(read, write)]
    fn transfer(recipient: Identity, amount: u64) {
        let sender = msg_sender().unwrap();

        // Check sender balance
        let sender_balance = storage.balances.get(sender).try_read().unwrap_or(0);
        require(sender_balance >= amount, "Insufficient balance");

        // Update balances
        storage.balances.insert(sender, sender_balance - amount);

        let recipient_balance = storage.balances.get(recipient).try_read().unwrap_or(0);
        storage.balances.insert(recipient, recipient_balance + amount);

        log(TransferEvent {
            from: sender,
            to: recipient,
            amount: amount,
        });
    }

    #[storage(read, write)]
    fn mint(amount: u64, recipient: Identity) {
        let sender = msg_sender().unwrap();
        // In production, add access control here

        let recipient_balance = storage.balances.get(recipient).try_read().unwrap_or(0);
        storage.balances.insert(recipient, recipient_balance + amount);

        let new_supply = storage.total_supply.read() + amount;
        storage.total_supply.write(new_supply);

        log(TransferEvent {
            from: ZERO_B256,
            to: recipient,
            amount: amount,
        });
    }

    #[storage(read, write)]
    fn burn(amount: u64) {
        let sender = msg_sender().unwrap();

        let sender_balance = storage.balances.get(sender).try_read().unwrap_or(0);
        require(sender_balance >= amount, "Insufficient balance to burn");

        storage.balances.insert(sender, sender_balance - amount);

        let new_supply = storage.total_supply.read() - amount;
        storage.total_supply.write(new_supply);

        log(TransferEvent {
            from: sender,
            to: ZERO_B256,
            amount: amount,
        });
    }
}

struct TransferEvent {
    from: Identity,
    to: Identity,
    amount: u64,
}

const ZERO_B256: Identity = Identity::Address(Address::from(0x0000000000000000000000000000000000000000000000000000000000000000));
