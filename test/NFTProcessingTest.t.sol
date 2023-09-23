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
    address alice;
    address bob;

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

    function testEditEdition(
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

    function testMintEdition(uint256 amount) public {
        amount = bound(amount, 0, usd.balanceOf(alice));

        uint256 aliceBalanceBefore = usd.balanceOf(alice);

        vm.startPrank(alice);
        usd.approve(address(account), amount);
        account.deposit(address(usd), amount);
        vm.stopPrank();

        uint256 aliceBalanceAfter = usd.balanceOf(alice);

        try usd.totalSupply(50) { }
        catch (bytes memory /* error */){ }

        assertEq(account.balances(address(usd)), amount);
        assertEq(usd.balanceOf(address(account)), amount);
        assertEq(aliceBalanceBefore - aliceBalanceAfter, amount);
    }

    function testOwnerShipTransferRole() {
        vm.startPrank(alice);
        usd.transferOwnerShip(bob);
        vm.startPrank(bob);
        // try admin function, shoulddn't give an error
        try usd.totalSupply(50) { }
        catch (bytes memory /* error */){ }
    }
}
