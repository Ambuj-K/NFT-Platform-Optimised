// SPDX-License-Identifier: MIT

/// @author @ambuj-k 

/// @title This is a varied range ERC1155 NFT token contract

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "../utils/ERC712Custom.sol";

contract NFT1155Custom is ERC1155, INFT1155Custom, ERC712Custom, Pausable {

  address public _owner;
  address private newOwner;

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

  constructor(address __owner) {
    _owner = _owner;
    // Initialize the total supply to 0.
    totalSupply = 0;
  }

  event OwnershipTransferCompleted(address owner, address pendingOwner);
  event OwnershipTransferInitiated(address owner, address pendingOwner);

  bytes32 private constant _TRANSFER_OWNERSHIP_TYPEHASH =
        keccak256("TransferOwnership(address _new_owner,address _owner,uint256 nonce,uint256 deadline)");

  modifier onlyAuthorizedTransferOwnership(address target,uint256 deadline,bytes32 _typehash,bytes memory signature){

        processSignatureVerification(abi.encode(_typehash,target,_owner,nonces[_owner],deadline), signature, deadline, _owner);
     _; }

  bytes32 private constant _PENDING_OWNER_TYPEHASH = keccak256("ClaimOwnerRole(uint256 nonce,uint256 deadline)");

  modifier onlyAuthorizedPendingOwner(uint256 deadline,bytes32 _typehash,bytes memory signature){

      processSignatureVerification(abi.encode(_typehash,_owner,nonces[_owner], deadline), signature, deadline, pendingOwner);
  _; } 

  function transferOwnership(address newOwner,uint256 deadline, bytes memory signature) public onlyAuthorizedTransferOwnership(newOwner,deadline,_TRANSFER_OWNERSHIP_TYPEHASH,signature) {

        if(newOwner == address(0)){revert Error_Invalid_NewOwner_Address();}

        _transferOwnership(newOwner); }

  /**
     * @dev Transfers ownership of the contract to the pending owner (`pendingOwner`).
     * Can only be called by the pending owner.
  */

  function claimOwnerRole(uint256 deadline, bytes memory signature) public onlyAuthorizedPendingOwner(deadline,_PENDING_OWNER_TYPEHASH,signature) {

      emit OwnershipTransferCompleted(_owner, pendingOwner);

      _owner = pendingOwner;

      pendingOwner = address(0);
    }

  /**
     * @dev Makes (`newOwner`) the pendingOwner.
     * Internal function without access restriction.
  */
  function _transferOwnership(address newOwner) internal {

      pendingOwner = newOwner;

      emit OwnershipTransferInitiated(_owner, newOwner); 
  }

  // Mint a new limited release NFT.
  function mint(uint256 tokenId, address owner, string memory uri, uint256 type_nft, string memory name, string memory description, uint256 rarity) public external {
    // Check that the token ID is not already in use.
    if (tokenOwners[tokenId] != address(0)){
      revert Error_Token_Address_Used();
    }

    // Mint the NFT.
    LimitedReleaseNFT memory nft = LimitedReleaseNFT(tokenId, type, block.timestamp, name, description, rarity);
    tokenOwners[tokenId] = owner;
    tokenURIs[tokenId] = uri;
    tokenTypes[tokenId] = type_nft;

    // Increment the total supply.
    totalSupply++;
  }

    struct Edition {
        uint256 price;
        uint256 openingTime;
        string code;
        string details;
        address[] splits;
        uint256 royalties;
    }

    mapping(uint256 => Edition) public editions;
    uint256 public totalEditions;

    constructor() ERC1155("https://example.com/api/token/{id}.json") {}

    function createEdition(
        uint256 _price,
        uint256 _openingTime,
        string memory _code,
        string memory _details,
        address[] memory _splits,
        uint256 _royalties
    ) external onlyOwner {
        require(_price > 0, "Price must be greater than zero");
        require(_splits.length > 0, "Splits array must not be empty");
        require(_royalties <= 100, "Royalties percentage must be between 0 and 100");
        uint256 editionId = totalEditions++;
        editions[editionId] = Edition({
            price: _price,
            openingTime: _openingTime,
            code: _code,
            details: _details,
            splits: _splits,
            royalties: _royalties
        });
    }

    function updateEdition(
        uint256 editionId,
        uint256 _price,
        uint256 _openingTime,
        string memory _code,
        string memory _details,
        address[] memory _splits,
        uint256 _royalties
    ) external onlyOwner {
        require(editionId < totalEditions, "Edition does not exist");
        require(_price > 0, "Price must be greater than zero");
        require(_splits.length > 0, "Splits array must not be empty");
        require(_royalties <= 100, "Royalties percentage must be between 0 and 100");

        editions[editionId].price = _price;
        editions[editionId].openingTime = _openingTime;
        editions[editionId].code = _code;
        editions[editionId].details = _details;
        editions[editionId].splits = _splits;
        editions[editionId].royalties = _royalties;
    }
  
}
