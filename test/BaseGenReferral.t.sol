// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BaseGen.sol";

contract BaseGenReferralTest is Test {
    BaseGen public instance;
    uint256 public constant pricePerMint = 0.0015 ether;
    uint256 public constant quantity = 10;
    address public initialOwner;
    address public receiver;
    uint256 public maxSupply = 20;

    function setUp() public {
        initialOwner = vm.addr(1);
        receiver = vm.addr(2);
        string memory name = "Generative";
        string memory symbol = "GEN";
        string memory contractURI = "ipfs://";
        string memory baseURI = "https://data.kodadot.xyz/base/"; // suffixed with /?hash=
        instance = new BaseGen(initialOwner, name, symbol, contractURI, baseURI, maxSupply, receiver);
    }

    function testMintWithReferral() public {
        address tokenOwner = vm.addr(3);
        address referrer = vm.addr(4);

        // Calculate the total cost for minting
        uint256 totalCost = pricePerMint * quantity;
        vm.deal(tokenOwner, totalCost);

        // Assert initial state
        assertEq(instance.totalSupply(), 0);

        // Prank msg.sender as initialOwner to simulate the mint transaction
        vm.prank(tokenOwner);

        // Send sufficient funds to mint
        instance.mintWithReferral{value: totalCost}(tokenOwner, quantity, referrer);

        // Assert that totalSupply is updated correctly
        assertEq(instance.totalSupply(), quantity);

        // Assert the owner of the newly minted tokens
        for (uint256 i = 0; i < quantity; i++) {
            assertEq(instance.ownerOf(i), tokenOwner);
        }

        // Assert that the contract balance is transferred correctly
        uint256 receiverBalance = totalCost / 2;
        assertEq(receiver.balance, receiverBalance);
        uint256 referrerBalance = totalCost / 20;
        assertEq(referrer.balance, referrerBalance);
        assertEq(initialOwner.balance, receiverBalance- referrerBalance);
    }

}
