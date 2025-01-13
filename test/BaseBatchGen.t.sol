// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BaseGen.sol";

// https://hackernoon.com/implementing-the-erc-2981-nft-royalty-standard-with-solidity
contract BaseBatchGenTest is Test {
    BaseGen public instance;
    uint256 public constant pricePerMint = 0.0015 ether;
    uint256 public constant quantity = 10;
    address public initialOwner;
    uint256 public maxSupply = 20;

    function setUp() public {
        initialOwner = vm.addr(1);
        string memory name = "Generative";
        string memory symbol = "GEN";
        string memory contractURI = "ipfs://";
        string memory baseURI = "https://data.kodadot.xyz/base/"; // suffixed with /?hash=
        address receiver = vm.addr(2);
        instance = new BaseGen(initialOwner, name, symbol, contractURI, baseURI, maxSupply, receiver);
        
        // instance.safeBatchMint{value: pricePerMint * pieces}(initialOwner, pieces);
        // instance.setMaxSupply(128);
    }

    function testSafeBatchMint() public {

        // Calculate the total cost for minting
        uint256 totalCost = pricePerMint * quantity;
        vm.deal(initialOwner, totalCost);

        // Assert initial state
        assertEq(instance.totalSupply(), 0);

        // Prank msg.sender as initialOwner to simulate the mint transaction
        vm.prank(initialOwner);

        // Send sufficient funds to mint
        instance.safeBatchMint{value: totalCost}(initialOwner, quantity);

        // Assert that totalSupply is updated correctly
        assertEq(instance.totalSupply(), quantity);

        // Assert the owner of the newly minted tokens
        for (uint256 i = 0; i < quantity; i++) {
            assertEq(instance.ownerOf(i), initialOwner);
        }

        // Assert that the contract balance is transferred correctly
        uint256 expectedBalance = totalCost / 2;
        address receiver = vm.addr(2);
        assertEq(receiver.balance, expectedBalance);
        assertEq(initialOwner.balance, expectedBalance);
    }

    function testSafeBatchMintExceedsMaxSupply() public {
        uint256 quantity = maxSupply + 1;
        uint256 totalCost = pricePerMint * quantity;
        vm.deal(initialOwner, totalCost);
        vm.prank(initialOwner);
        vm.expectRevert(abi.encodeWithSelector(BaseGen.MintQuantityExceedsMaxSupply.selector, 0, maxSupply));
        instance.safeBatchMint{value: totalCost}(initialOwner, quantity);
    }

    function testSafeBatchMintInsufficientFunds() public {
        uint256 totalCost = pricePerMint * (quantity);
        uint256 totalPaid = pricePerMint * (quantity - 1); // Pay less than the total cost
        vm.deal(initialOwner, totalPaid);
        vm.prank(initialOwner);
        vm.expectRevert(abi.encodeWithSelector(BaseGen.InsufficientFunds.selector, totalCost, totalPaid));
        instance.safeBatchMint{value: totalPaid}(initialOwner, quantity);
    }

    function testSafeBatchMintQuantityCannotBeZero() public {
        vm.deal(initialOwner, pricePerMint);
        vm.prank(initialOwner);
        vm.expectRevert(BaseGen.MintQuantityCannotBeZero.selector);
        instance.safeBatchMint{value: pricePerMint}(initialOwner, 0);
    }
}
