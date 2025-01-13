// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BaseGen.sol";

// https://hackernoon.com/implementing-the-erc-2981-nft-royalty-standard-with-solidity
contract BaseGenTest is Test {
    BaseGen public instance;
    uint256 public constant pricePerMint = 0.0015 ether;
    address public initialOwner;

    function setUp() public {
        initialOwner = vm.addr(1);
        string memory name = "Generative";
        string memory symbol = "GEN";
        string memory contractURI = "ipfs://";
        string memory baseURI = "https://data.kodadot.xyz/base/"; // suffixed with /?hash=
        uint256 maxSupply = 256;
        address receiver = vm.addr(2);
        instance = new BaseGen(initialOwner, name, symbol, contractURI, baseURI, maxSupply, receiver);
        instance.safeMint{value: pricePerMint}(initialOwner);
    }

    function testName() public view {
        assertEq(instance.name(), "Generative");
    }

    function testContractUri() public view {
        assertEq(instance.contractURI(), "ipfs://");
    }

    function testBaseUri() public view {
        string memory baseUri = "https://data.kodadot.xyz/base/";
        string memory scAddress = Strings.toHexString(uint160(address(instance)), 20);
        string memory expected = string.concat(baseUri, scAddress, "/");
        assertEq(instance.baseURI(), expected);
    }

    function testTokenUri() public view {
        string memory baseUri = "https://data.kodadot.xyz/base/";
        string memory scAddress = Strings.toHexString(uint160(address(instance)), 20);
        string memory expected = string.concat(baseUri, scAddress, "/");

        assertEq(instance.tokenURI(0), string.concat(expected, "0"));
    }

    function testRoyalty() public view {
        (address receiver, uint256 amount) = instance.royaltyInfo(0, 1 ether);
        assertEq(receiver, vm.addr(2));
        assertEq(amount, 0.05 ether);
    }


    function testValue() public view {
        address receiver = vm.addr(2);
        assertEq(receiver.balance, pricePerMint / 2);
        assertEq(initialOwner.balance, pricePerMint / 2);
    }

    function testTotalSupply() public {
        assertEq(instance.totalSupply(), 1);
        
        // Mint another token
        vm.deal(address(0x123), pricePerMint); // Ensure the address has enough ETH
        vm.prank(address(0x123));
        instance.safeMint{value: pricePerMint}(address(0x123));
        
        assertEq(instance.totalSupply(), 2);

        // Mint some tokens
        for (uint256 i = 0; i < 5; i++) {
            vm.deal(address(0x123), pricePerMint); // Ensure the address has enough ETH
            vm.prank(address(0x123));
            instance.safeMint{value: pricePerMint}(address(0x123));
        }

        assertEq(instance.totalSupply(), 7);
    }

    function testMaxSupply() public {
        assertEq(instance.maxSupply(), 256);
        
        // Test changing max supply
        uint256 newMaxSupply = 128;
        vm.prank(initialOwner);
        vm.expectEmit();
        emit BaseGen.MaxSupplyUpdated(newMaxSupply);
        instance.setMaxSupply(newMaxSupply);
        assertEq(instance.maxSupply(), newMaxSupply);
    }

    function testMintExceedsMaxSupply() public {
        // Get the current max supply
        uint256 initialMaxSupply = instance.maxSupply();
        
        // Set a new, lower max supply
        uint256 newMaxSupply = 10;
        vm.prank(initialOwner);
        vm.expectEmit();
        emit BaseGen.MaxSupplyUpdated(newMaxSupply);
        instance.setMaxSupply(newMaxSupply);
        
        // Verify the new max supply
        assertEq(instance.maxSupply(), newMaxSupply);
        
        // Mint tokens until we reach one less than the new max supply
        for (uint256 i = instance.totalSupply(); i < newMaxSupply - 1; i++) {
            vm.deal(address(0x123), pricePerMint);
            vm.prank(address(0x123));
            instance.safeMint{value: pricePerMint}(address(0x123));
        }
        
        // Verify we're at one less than new max supply
        assertEq(instance.totalSupply(), newMaxSupply - 1);
        
        // Mint one more token, which should succeed
        vm.deal(address(0x456), pricePerMint);
        vm.prank(address(0x456));
        instance.safeMint{value: pricePerMint}(address(0x456));
        
        // Verify we've reached new max supply
        assertEq(instance.totalSupply(), newMaxSupply);
        
        // Now try to mint one more token, which should revert
        vm.deal(address(0x789), pricePerMint);
        vm.prank(address(0x789));
        vm.expectRevert(abi.encodeWithSelector(BaseGen.MintQuantityExceedsMaxSupply.selector, newMaxSupply, newMaxSupply));
        instance.safeMint{value: pricePerMint}(address(0x789));
        
        // Try to set max supply lower than current total supply, which should revert
        vm.prank(initialOwner);
        vm.expectRevert(abi.encodeWithSelector(BaseGen.MintQuantityExceedsMaxSupply.selector, newMaxSupply-1, newMaxSupply));
        instance.setMaxSupply(newMaxSupply - 1);
        
        // Verify max supply hasn't changed
        assertEq(instance.maxSupply(), newMaxSupply);
        
        // Set max supply back to initial value
        vm.prank(initialOwner);
        vm.expectEmit();
        emit BaseGen.MaxSupplyUpdated(initialMaxSupply);
        instance.setMaxSupply(initialMaxSupply);
        
        // Verify max supply has been restored
        assertEq(instance.maxSupply(), initialMaxSupply);
    }
}