module coin_flip_addr::coin_flip {
    use std::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::timestamp;

    /// Error codes
    const E_GAME_NOT_FOUND: u64 = 1;
    const E_INSUFFICIENT_BALANCE: u64 = 2;
    const E_GAME_ALREADY_EXISTS: u64 = 3;

    /// Game state
    struct Game has key {
        bet_amount: u64,
        wins: u64,
        losses: u64,
        last_played: u64,
    }

    /// Initialize game for a player
    public entry fun initialize(player: &signer) {
        let player_addr = signer::address_of(player);
        assert!(!exists<Game>(player_addr), E_GAME_ALREADY_EXISTS);

        move_to(player, Game {
            bet_amount: 0,
            wins: 0,
            losses: 0,
            last_played: 0,
        });
    }

    /// Play coin flip game
    public entry fun play(
        player: &signer,
        bet_amount: u64,
        guess_heads: bool
    ) acquires Game {
        let player_addr = signer::address_of(player);
        assert!(exists<Game>(player_addr), E_GAME_NOT_FOUND);

        // Check balance
        let balance = coin::balance<AptosCoin>(player_addr);
        assert!(balance >= bet_amount, E_INSUFFICIENT_BALANCE);

        // Simple randomness based on timestamp (not secure for production!)
        let current_time = timestamp::now_microseconds();
        let is_heads = (current_time % 2) == 0;

        let game = borrow_global_mut<Game>(player_addr);
        game.bet_amount = bet_amount;
        game.last_played = current_time;

        if (is_heads == guess_heads) {
            game.wins = game.wins + 1;
            // Winner gets 2x (in production, handle actual coin transfer)
        } else {
            game.losses = game.losses + 1;
            // Loser loses bet (in production, transfer coins to house)
        }
    }

    /// Get game stats
    #[view]
    public fun get_stats(player_addr: address): (u64, u64, u64) acquires Game {
        assert!(exists<Game>(player_addr), E_GAME_NOT_FOUND);
        let game = borrow_global<Game>(player_addr);
        (game.wins, game.losses, game.last_played)
    }

    /// Get win rate as percentage
    #[view]
    public fun get_win_rate(player_addr: address): u64 acquires Game {
        assert!(exists<Game>(player_addr), E_GAME_NOT_FOUND);
        let game = borrow_global<Game>(player_addr);
        let total_games = game.wins + game.losses;

        if (total_games == 0) {
            return 0
        };

        (game.wins * 100) / total_games
    }

    #[test(player = @0x1)]
    public fun test_initialize(player: &signer) {
        initialize(player);
        let player_addr = signer::address_of(player);
        assert!(exists<Game>(player_addr), 0);
    }

    #[test(player = @0x1)]
    #[expected_failure(abort_code = E_GAME_ALREADY_EXISTS)]
    public fun test_double_initialize(player: &signer) {
        initialize(player);
        initialize(player);
    }
}
