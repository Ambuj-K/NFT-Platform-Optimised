// SPDX-License-Identifier: MIT

//@author @ambuj-k

pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../src/NFT1155Custom.sol";
import "../src/NFTProcessing.sol";

interface CheatCodes {
    function startPrank(address) external;
    function stopPrank() external;
    function expectEmit(bool, bool, bool, bool) external;
    function warp(uint256) external;
    function roll(uint256) external;
    function prank(address) external;
}

contract NFTProcessingTest is Test {
    NFT1155Custom tokenObj;
    NFTProcessing minterObj;

    uint16 tokenId;
    function setUp() public {
        alice = makeAddr("Alice");
        bob = makeAddr("Bob");

        usd.mint(alice, 1000 ether);
        usd.mint(bob, 1000 ether);
        eur.mint(alice, 1000 ether);
        eur.mint(bob, 1000 ether);
        tokenId = usd.getID(); // token id
        tokenObj = new NFT1155Custom("LimRel", 2, 45 days);
        tokenObj.setOWner(address(0));
        minterObj = new NFTProcessing("Minter");
        minterObj.setOWner(address(0));
    }

    function testMetadata(){
        tokenObj.generateMetadata();
    }

    function testMintMax(){
        tokenObj.mintedAt(tokenId);
    }

    function testEditionUpdate(){
        cheats.prank(addr1);
        tokenObj.updateEdition();
    }

}