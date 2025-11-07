module nft_marketplace::simple_marketplace {
    use sui::object::{Self, UID, ID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::event;

    /// NFT struct
    struct NFT has key, store {
        id: UID,
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
    }

    /// Marketplace listing
    struct Listing has key {
        id: UID,
        nft_id: ID,
        seller: address,
        price: u64,
    }

    /// Events
    struct NFTMinted has copy, drop {
        nft_id: ID,
        minter: address,
        name: vector<u8>,
    }

    struct NFTListed has copy, drop {
        nft_id: ID,
        seller: address,
        price: u64,
    }

    struct NFTSold has copy, drop {
        nft_id: ID,
        seller: address,
        buyer: address,
        price: u64,
    }

    /// Mint a new NFT
    public entry fun mint_nft(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let nft = NFT {
            id: object::new(ctx),
            name,
            description,
            url,
        };

        event::emit(NFTMinted {
            nft_id: object::uid_to_inner(&nft.id),
            minter: sender,
            name: nft.name,
        });

        transfer::public_transfer(nft, sender);
    }

    /// List NFT for sale
    public entry fun list_nft(
        nft: NFT,
        price: u64,
        ctx: &mut TxContext
    ) {
        let nft_id = object::uid_to_inner(&nft.id);
        let sender = tx_context::sender(ctx);

        let listing = Listing {
            id: object::new(ctx),
            nft_id,
            seller: sender,
            price,
        };

        event::emit(NFTListed {
            nft_id,
            seller: sender,
            price,
        });

        // Transfer NFT to listing (held in escrow)
        transfer::public_transfer(nft, object::uid_to_address(&listing.id));
        transfer::share_object(listing);
    }

    /// Buy NFT from listing
    public entry fun buy_nft(
        listing: Listing,
        nft: NFT,
        payment: Coin<SUI>,
        ctx: &mut TxContext
    ) {
        let Listing {
            id,
            nft_id: _,
            seller,
            price,
        } = listing;

        let buyer = tx_context::sender(ctx);

        // Verify payment amount
        assert!(coin::value(&payment) >= price, 0);

        // Transfer payment to seller
        transfer::public_transfer(payment, seller);

        // Transfer NFT to buyer
        transfer::public_transfer(nft, buyer);

        event::emit(NFTSold {
            nft_id: object::uid_to_inner(&nft.id),
            seller,
            buyer,
            price,
        });

        object::delete(id);
    }

    /// Delist NFT (cancel listing)
    public entry fun delist_nft(
        listing: Listing,
        nft: NFT,
        ctx: &mut TxContext
    ) {
        let Listing {
            id,
            nft_id: _,
            seller,
            price: _,
        } = listing;

        let sender = tx_context::sender(ctx);

        // Only seller can delist
        assert!(sender == seller, 1);

        // Return NFT to seller
        transfer::public_transfer(nft, seller);

        object::delete(id);
    }

    /// Get NFT details (for off-chain querying)
    public fun get_nft_name(nft: &NFT): vector<u8> {
        nft.name
    }

    public fun get_nft_description(nft: &NFT): vector<u8> {
        nft.description
    }

    public fun get_nft_url(nft: &NFT): vector<u8> {
        nft.url
    }

    /// Get listing details
    public fun get_listing_price(listing: &Listing): u64 {
        listing.price
    }

    public fun get_listing_seller(listing: &Listing): address {
        listing.seller
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        // Test initialization
    }
}
