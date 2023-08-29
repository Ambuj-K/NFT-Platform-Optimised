// SPDX-License-Identifier: MIT

/// @author @ambuj-k 

/// @title This is a varied range minter contract

pragma solidity ^0.8.18;

import "../ERC712Custom.sol";
import "../INFT1155Custom.sol";

contract NFTProcessing is ERC712Custom {

    address public owner;

    // error list
    error Error_Only_NFT_Owner();
    error Error_Ahead_Of_Reveal_Time();
    error Error_Ahead_Of_Reveal_Time();
    error Error_Only_Owner();
    error Error_Unique_NFT_Mint();
    error Error_Price_Mismatch();

    modifier onlyAdmin() {
        if(msg.sender != admin) {revert Error_Only_Owner()};
        _;
    }

    // TODO Constructor
    constructor (address _owner){
        owner = _owner;
    }

    // mint NFT, for revelataion upon time
    function mintNFT() public payable {
        if(msg.value != price){ revert Error_Price_Mismatch(); };
        if(totalSupply() > 1){ revert Error_Unique_NFT_Mint(); };

        uint256 tokenId = totalSupply() + 1;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, "");
    }

    // reveal function 
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

    // generate Metadata for NFT
    function generateMetadata(uint256 tokenId) internal view returns (string memory) {
        // Generate random metadata for the NFT.
        return "This is the metadata for NFT #" + tokenId.toString();
    }

    // withdraw funds, more TODO
    function withdrawFunds(address _to) public onlyAdmin {
        uint256 totalFunds = totalSupply() * price;
        _transfer(address(0), _to, totalFunds);
    }

}

