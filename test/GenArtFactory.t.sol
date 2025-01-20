// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BaseGen.sol";
import "../src/GenArtFactory.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GenArtFactoryTest is Test {
    GenArtFactory public factory;
    uint256 public constant pricePerMint = 0.0015 ether;
    uint256 public constant quantity = 10;
    uint256 public maxSupply = 20;
    string public symbol = "GEN";
    string public contractURI = "ipfs://";
    string public baseURI = "https://data.kodadot.xyz/base/";
    address receiver = vm.addr(20);


    function setUp() public {
        BaseGen baseGen = new BaseGen();
        factory = new GenArtFactory(address(baseGen));
        
        // instance.safeBatchMint{value: pricePerMint * pieces}(initialOwner, pieces);
        // instance.setMaxSupply(128);
    }

    function testCreateGenArt() public {

        for (uint256 i = 0; i < quantity; i++) {
            address initialOwner = vm.addr(i+1);
            string memory name = string.concat("Generative", Strings.toString(i));

            vm.expectEmit(true,true,true,false);
            emit GenArtFactory.GenArtCreated(address(0));

            BaseGen instance = BaseGen(factory.createGenArt(initialOwner, name, symbol, contractURI, baseURI, maxSupply, receiver));

            // Assert initial state
            assertEq(instance.totalSupply(), 0);
            assertEq(instance.name(), name);

            // Calculate the total cost for minting
            uint256 totalCost = pricePerMint * quantity;
            vm.deal(initialOwner, totalCost);

            // Prank msg.sender as initialOwner to simulate the mint transaction
            vm.prank(initialOwner);

            // Send sufficient funds to mint
            instance.safeBatchMint{value: totalCost}(initialOwner, quantity);

            // Assert that totalSupply is updated correctly
            assertEq(instance.totalSupply(), quantity);
            // assertEq(instance.ownerOf(i), initialOwner);

            // Assert that the contract balance is transferred correctly
            uint256 expectedBalance = totalCost / 2;
            assertEq(receiver.balance, expectedBalance*(i+1));
            assertEq(initialOwner.balance, expectedBalance);
        }
       
    }

}
