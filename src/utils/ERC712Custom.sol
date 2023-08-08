// SPDX-License-Identifier: BSL-1.1

// Copyright (c)
// All rights reserved.

// This software is released under the Business Source License 1.1.
// For full license terms, see the LICENSE file.

pragma solidity 0.8.18;

/// @author Ambuj <Ambuj@add3.io>
/// @title ERC712Custom
/// This abstract class can be inherited and used by all contracts using the EIP712 functions

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "../privilegedaddressregistry/IPrivilegedAddressRegistry.sol";

abstract contract ERC712Custom is EIP712 {

    using ECDSA for bytes32;

    mapping(address => uint256) public nonces;

    IPrivilegedAddressRegistry privilegedAddressObj;

    error Error_Unauthorized_Signature();
    error Error_Unauthorized_Deadline_Expired();

    function processSignatureVerification(bytes memory encodedParams, bytes memory signature, uint256 deadline, address verificationAddr) internal{ 

        if (msg.sender != verificationAddr){
            if(block.timestamp > deadline){ revert Error_Unauthorized_Deadline_Expired();}

            address signer = ECDSA.recover(_hashTypedDataV4(keccak256(encodedParams)), signature);
            nonces[verificationAddr]++;
            if (verificationAddr != signer){ revert Error_Unauthorized_Signature();} } 
        }
}