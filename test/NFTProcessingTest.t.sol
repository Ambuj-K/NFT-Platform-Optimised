// SPDX-License-Identifier: MIT

//@author @ambuj-k

pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../src/NFT1155Custom.sol";
import "../src/NFTProcessing.sol";

contract NFTProcessingTest is Test {
    NFT1155Custom tokenObj;
    NFTProcessing minterObj;

    function setUp() public {
        tokenObj = new NFT1155Custom("LimRel", 2, 45 days);
        tokenObj.setOWner(address(0));
        minterObj = new NFTProcessing("Minter");
        minterObj.setOWner(address(0));
    }

    function testMint() public {
        minterObj.mint();
    }
}
