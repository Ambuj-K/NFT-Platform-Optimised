// SPDX-License-Identifier: MIT

/// @author @ambuj-k 

/// @title This is the interface for NFT1155Custom contract

pragma solidity ^0.8.18;

interface INFT1155Custom{

function mint(uint256 tokenId, address owner, string memory uri, uint256 NFTType, string memory name, string memory description, uint256 rarity) external;

function transferOwnership(address newOwner,uint256 deadline, bytes memory signature) external;

}