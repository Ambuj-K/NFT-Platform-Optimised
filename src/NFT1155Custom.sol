// SPDX-License-Identifier: MIT

/// @author @ambuj-k 

/// @title This is a 

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract NFT1155Custom is ERC1155, Pausable {

  error Error_Token_Address_Used();

  // The total number of NFTs that have been minted.
  uint256 public totalSupply;

  // The mapping from token ID to token owner.
  mapping(uint256 => address) public tokenOwners;

  // The mapping from token ID to token URI.
  mapping(uint256 => string) public tokenURIs;

  // The mapping from token ID to token type.
  mapping(uint256 => uint256) public tokenTypes;

  // The struct that represents a limited release NFT.
  struct LimitedReleaseNFT {
    uint256 tokenId;
    uint256 type;
    uint256 mintedAt;
    string name;
    string description;
    uint256 rarity;
  }

  constructor() {
    // Initialize the total supply to 0.
    totalSupply = 0;
  }

  // Mint a new limited release NFT.
  function mint(uint256 tokenId, address owner, string memory uri, uint256 type, string memory name, string memory description, uint256 rarity) public {
    // Check that the token ID is not already in use.
    if (tokenOwners[tokenId] != address(0)){
      revert Error_Token_Address_Used();
    }

    // Mint the NFT.
    LimitedReleaseNFT memory nft = LimitedReleaseNFT(tokenId, type, block.timestamp, name, description, rarity);
    tokenOwners[tokenId] = owner;
    tokenURIs[tokenId] = uri;
    tokenTypes[tokenId] = type;

    // Increment the total supply.
    totalSupply++;
  }

  // Get the owner of a given NFT.
  function tokenOwner(uint256 tokenId) public view returns (address) {
    return tokenOwners[tokenId];
  }

  // Get the URI of a given NFT.
  function tokenURI(uint256 tokenId) public view returns (string) {
    return tokenURIs[tokenId];
  }

  // Get the type of a given NFT.
  function tokenType(uint256 tokenId) public view returns (uint256) {
    return tokenTypes[tokenId];
  }

  // Get the minted at timestamp of a given NFT.
  function mintedAt(uint256 tokenId) public view returns (uint256) {
    return LimitedReleaseNFT(tokenId, tokenTypes[tokenId], 0).mintedAt;
  }

  // Get the name of a given NFT.
  function name(uint256 tokenId) public view returns (string) {
    return LimitedReleaseNFT(tokenId, tokenTypes[tokenId], 0).name;
  }

  // Get the description of a given NFT.
  function description(uint256 tokenId) public view returns (string) {
    return LimitedReleaseNFT(tokenId, tokenTypes[tokenId], 0).description;
  }

  // Get the rarity of a given NFT.
  function rarity(uint256 tokenId) public view returns (uint256) {
    return LimitedReleaseNFT(tokenId, tokenTypes[tokenId], 0).rarity;
  }
}
