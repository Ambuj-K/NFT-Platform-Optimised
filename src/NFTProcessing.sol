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

    // events
    event EditionUpdated(uint245 tokenid);
    event EditionCreated(uint256 tokenid);
    event ClaimedNFTToken(uint256 tokenid);
    event MintedNFTToken(uint256 tokenid);

    modifier onlyAdmin() {
        if(msg.sender != admin) {revert Error_Only_Owner()};
        _;
    }

    // TODO Constructor
    constructor (address _owner){
        owner = _owner;
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

