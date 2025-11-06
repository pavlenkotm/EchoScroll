// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EchoScroll
 * @dev A magical blockchain library where posts can only be deleted with secret spells
 */
contract EchoScroll {
    struct Scroll {
        uint256 id;
        address author;
        string ipfsHash;
        bytes32 spellHash;
        uint256 timestamp;
        bool exists;
        string title;
    }

    uint256 private scrollCounter;
    mapping(uint256 => Scroll) public scrolls;
    mapping(address => uint256[]) public authorScrolls;
    uint256[] public activeScrollIds;

    event ScrollPublished(
        uint256 indexed id,
        address indexed author,
        string ipfsHash,
        string title,
        uint256 timestamp
    );

    event ScrollDeleted(
        uint256 indexed id,
        address indexed author,
        uint256 timestamp
    );

    event SpellCast(
        uint256 indexed id,
        address indexed caster,
        bool success
    );

    modifier onlyAuthor(uint256 _scrollId) {
        require(
            scrolls[_scrollId].author == msg.sender,
            "Only the author can cast this spell"
        );
        _;
    }

    modifier scrollExists(uint256 _scrollId) {
        require(scrolls[_scrollId].exists, "This scroll has vanished");
        _;
    }

    /**
     * @dev Publish a new scroll to the eternal library
     * @param _ipfsHash IPFS hash of the scroll content
     * @param _spellHash Keccak256 hash of the secret deletion spell
     * @param _title Title of the scroll
     */
    function publishScroll(
        string memory _ipfsHash,
        bytes32 _spellHash,
        string memory _title
    ) external returns (uint256) {
        require(bytes(_ipfsHash).length > 0, "IPFS hash cannot be empty");
        require(_spellHash != bytes32(0), "Spell hash cannot be empty");
        require(bytes(_title).length > 0, "Title cannot be empty");

        scrollCounter++;
        uint256 newScrollId = scrollCounter;

        scrolls[newScrollId] = Scroll({
            id: newScrollId,
            author: msg.sender,
            ipfsHash: _ipfsHash,
            spellHash: _spellHash,
            timestamp: block.timestamp,
            exists: true,
            title: _title
        });

        authorScrolls[msg.sender].push(newScrollId);
        activeScrollIds.push(newScrollId);

        emit ScrollPublished(
            newScrollId,
            msg.sender,
            _ipfsHash,
            _title,
            block.timestamp
        );

        return newScrollId;
    }

    /**
     * @dev Cast a deletion spell to remove a scroll
     * @param _scrollId ID of the scroll to delete
     * @param _spell The secret spell phrase
     */
    function castDeletionSpell(uint256 _scrollId, string memory _spell)
        external
        onlyAuthor(_scrollId)
        scrollExists(_scrollId)
    {
        bytes32 spellHash = keccak256(abi.encodePacked(_spell));
        bool success = spellHash == scrolls[_scrollId].spellHash;

        emit SpellCast(_scrollId, msg.sender, success);

        require(success, "The spell was incorrectly cast");

        scrolls[_scrollId].exists = false;

        // Remove from activeScrollIds
        _removeFromActiveScrolls(_scrollId);

        emit ScrollDeleted(_scrollId, msg.sender, block.timestamp);
    }

    /**
     * @dev Get all active scroll IDs
     */
    function getActiveScrolls() external view returns (uint256[] memory) {
        uint256 activeCount = 0;
        for (uint256 i = 0; i < activeScrollIds.length; i++) {
            if (scrolls[activeScrollIds[i]].exists) {
                activeCount++;
            }
        }

        uint256[] memory result = new uint256[](activeCount);
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < activeScrollIds.length; i++) {
            if (scrolls[activeScrollIds[i]].exists) {
                result[currentIndex] = activeScrollIds[i];
                currentIndex++;
            }
        }

        return result;
    }

    /**
     * @dev Get scroll details
     */
    function getScroll(uint256 _scrollId)
        external
        view
        scrollExists(_scrollId)
        returns (
            uint256 id,
            address author,
            string memory ipfsHash,
            uint256 timestamp,
            string memory title
        )
    {
        Scroll memory scroll = scrolls[_scrollId];
        return (
            scroll.id,
            scroll.author,
            scroll.ipfsHash,
            scroll.timestamp,
            scroll.title
        );
    }

    /**
     * @dev Get scrolls by author
     */
    function getScrollsByAuthor(address _author)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory authorScrollList = authorScrolls[_author];
        uint256 existingCount = 0;

        for (uint256 i = 0; i < authorScrollList.length; i++) {
            if (scrolls[authorScrollList[i]].exists) {
                existingCount++;
            }
        }

        uint256[] memory result = new uint256[](existingCount);
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < authorScrollList.length; i++) {
            if (scrolls[authorScrollList[i]].exists) {
                result[currentIndex] = authorScrollList[i];
                currentIndex++;
            }
        }

        return result;
    }

    /**
     * @dev Get total number of scrolls ever published
     */
    function getTotalScrolls() external view returns (uint256) {
        return scrollCounter;
    }

    /**
     * @dev Internal function to remove scroll from active list
     */
    function _removeFromActiveScrolls(uint256 _scrollId) private {
        for (uint256 i = 0; i < activeScrollIds.length; i++) {
            if (activeScrollIds[i] == _scrollId) {
                activeScrollIds[i] = activeScrollIds[activeScrollIds.length - 1];
                activeScrollIds.pop();
                break;
            }
        }
    }

    /**
     * @dev Check if a scroll exists
     */
    function scrollExistsPublic(uint256 _scrollId) external view returns (bool) {
        return scrolls[_scrollId].exists;
    }
}
