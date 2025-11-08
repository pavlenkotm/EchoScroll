// SPDX-License-Identifier: MIT
// Cairo ERC-20 Token Implementation for StarkNet
// A simple but production-ready token contract demonstrating Cairo's syntax

#[starknet::contract]
mod ERC20Token {
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use core::num::traits::Zero;

    #[storage]
    struct Storage {
        name: felt252,
        symbol: felt252,
        decimals: u8,
        total_supply: u256,
        balances: LegacyMap<ContractAddress, u256>,
        allowances: LegacyMap<(ContractAddress, ContractAddress), u256>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer: Transfer,
        Approval: Approval,
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        #[key]
        from: ContractAddress,
        #[key]
        to: ContractAddress,
        value: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct Approval {
        #[key]
        owner: ContractAddress,
        #[key]
        spender: ContractAddress,
        value: u256,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: felt252,
        symbol: felt252,
        decimals: u8,
        initial_supply: u256,
        recipient: ContractAddress
    ) {
        self.name.write(name);
        self.symbol.write(symbol);
        self.decimals.write(decimals);
        self.total_supply.write(initial_supply);
        self.balances.write(recipient, initial_supply);

        self.emit(Transfer {
            from: Zero::zero(),
            to: recipient,
            value: initial_supply
        });
    }

    #[external(v0)]
    fn name(self: @ContractState) -> felt252 {
        self.name.read()
    }

    #[external(v0)]
    fn symbol(self: @ContractState) -> felt252 {
        self.symbol.read()
    }

    #[external(v0)]
    fn decimals(self: @ContractState) -> u8 {
        self.decimals.read()
    }

    #[external(v0)]
    fn total_supply(self: @ContractState) -> u256 {
        self.total_supply.read()
    }

    #[external(v0)]
    fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
        self.balances.read(account)
    }

    #[external(v0)]
    fn allowance(
        self: @ContractState,
        owner: ContractAddress,
        spender: ContractAddress
    ) -> u256 {
        self.allowances.read((owner, spender))
    }

    #[external(v0)]
    fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
        let sender = get_caller_address();
        self._transfer(sender, recipient, amount);
        true
    }

    #[external(v0)]
    fn transfer_from(
        ref self: ContractState,
        sender: ContractAddress,
        recipient: ContractAddress,
        amount: u256
    ) -> bool {
        let caller = get_caller_address();
        let current_allowance = self.allowances.read((sender, caller));

        assert(current_allowance >= amount, 'Insufficient allowance');

        self.allowances.write((sender, caller), current_allowance - amount);
        self._transfer(sender, recipient, amount);
        true
    }

    #[external(v0)]
    fn approve(ref self: ContractState, spender: ContractAddress, amount: u256) -> bool {
        let owner = get_caller_address();
        self.allowances.write((owner, spender), amount);

        self.emit(Approval { owner, spender, value: amount });
        true
    }

    // Internal function for transfers
    fn _transfer(
        ref self: ContractState,
        sender: ContractAddress,
        recipient: ContractAddress,
        amount: u256
    ) {
        assert(!sender.is_zero(), 'Transfer from zero address');
        assert(!recipient.is_zero(), 'Transfer to zero address');

        let sender_balance = self.balances.read(sender);
        assert(sender_balance >= amount, 'Insufficient balance');

        self.balances.write(sender, sender_balance - amount);
        self.balances.write(recipient, self.balances.read(recipient) + amount);

        self.emit(Transfer { from: sender, to: recipient, value: amount });
    }
}
