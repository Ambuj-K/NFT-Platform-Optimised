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
        alice = makeAddr("Alice");
        bob = makeAddr("Bob");

        usd.mint(alice, 1000 ether);
        usd.mint(bob, 1000 ether);
        eur.mint(alice, 1000 ether);
        eur.mint(bob, 1000 ether);
        tokenObj = new NFT1155Custom("LimRel", 2, 45 days);
        tokenObj.setOWner(address(0));
        minterObj = new NFTProcessing("Minter");
        minterObj.setOWner(address(0));
    }

    function testMint() public {
        minterObj.mint();
    }

    function testWithdraw(
        uint256 depositAmount,
        uint256 withdrawAmount
    ) public {
        depositAmount = bound(depositAmount, 0, usd.balanceOf(alice));
        withdrawAmount = bound(withdrawAmount, 0, depositAmount);

        vm.startPrank(alice);
        usd.approve(address(account), depositAmount);
        account.deposit(address(usd), depositAmount);
        vm.stopPrank();

        uint256 aliceBalanceBefore = usd.balanceOf(alice);

    }
}
