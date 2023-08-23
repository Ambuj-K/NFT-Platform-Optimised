// SPDX-License-Identifier: MIT

/// @author @ambuj-k 

/// @title This is a varied range minter contract

pragma solidity ^0.8.18;

import "../ERC712Custom.sol";
import "../INFT1155Custom.sol";

contract NFTProcessing is ERC712Custom {

function revealNFT(uint256 tokenId) public {
        if (!_isApprovedOrOwner(msg.sender, tokenId)){
            revert Error_Only_NFT_Owner();
        }
        if (block.timestamp > startTime){ 
            revert Error_Ahead_Of_Reveal_Time();
        }

        string memory metadata = generateMetadata(tokenId);
        _setTokenURI(tokenId, metadata);
    }

function generateMetadata(uint256 tokenId) internal view returns (string memory) {
        // Generate random metadata for the NFT.
        return "This is the metadata for NFT #" + tokenId.toString();
    }

modifier onlyAdmin() {
        if(msg.sender != admin) {revert Error_Only_Owner()};
        _;
    }

}

