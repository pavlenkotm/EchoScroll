// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title NFTMarketplace
 * @dev Simple NFT marketplace with listing and buying functionality
 */
contract NFTMarketplace is ReentrancyGuard {
    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    mapping(bytes32 => Listing) public listings;
    uint256 public listingFee = 0.025 ether;
    address payable public feeRecipient;

    event NFTListed(
        bytes32 indexed listingId,
        address indexed seller,
        address indexed nftContract,
        uint256 tokenId,
        uint256 price
    );

    event NFTSold(
        bytes32 indexed listingId,
        address indexed buyer,
        uint256 price
    );

    event ListingCancelled(bytes32 indexed listingId);

    constructor() {
        feeRecipient = payable(msg.sender);
    }

    function listNFT(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) external payable nonReentrant returns (bytes32) {
        require(msg.value >= listingFee, "Insufficient listing fee");
        require(price > 0, "Price must be greater than 0");

        IERC721 nft = IERC721(nftContract);
        require(nft.ownerOf(tokenId) == msg.sender, "Not token owner");
        require(
            nft.isApprovedForAll(msg.sender, address(this)) ||
            nft.getApproved(tokenId) == address(this),
            "Marketplace not approved"
        );

        bytes32 listingId = keccak256(
            abi.encodePacked(nftContract, tokenId, msg.sender, block.timestamp)
        );

        listings[listingId] = Listing({
            seller: msg.sender,
            nftContract: nftContract,
            tokenId: tokenId,
            price: price,
            active: true
        });

        feeRecipient.transfer(listingFee);

        emit NFTListed(listingId, msg.sender, nftContract, tokenId, price);

        return listingId;
    }

    function buyNFT(bytes32 listingId) external payable nonReentrant {
        Listing storage listing = listings[listingId];

        require(listing.active, "Listing not active");
        require(msg.value >= listing.price, "Insufficient payment");

        listing.active = false;

        IERC721(listing.nftContract).safeTransferFrom(
            listing.seller,
            msg.sender,
            listing.tokenId
        );

        payable(listing.seller).transfer(listing.price);

        if (msg.value > listing.price) {
            payable(msg.sender).transfer(msg.value - listing.price);
        }

        emit NFTSold(listingId, msg.sender, listing.price);
    }

    function cancelListing(bytes32 listingId) external {
        Listing storage listing = listings[listingId];

        require(listing.seller == msg.sender, "Not seller");
        require(listing.active, "Listing not active");

        listing.active = false;

        emit ListingCancelled(listingId);
    }

    function updateListingFee(uint256 newFee) external {
        require(msg.sender == feeRecipient, "Not authorized");
        listingFee = newFee;
    }
}
