// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Generative.sol";

contract GenerativeTest is Test {
    Generative public instance;

    function setUp() public {
        address initialOwner = vm.addr(1);
        string memory name = "Generative";
        string memory symbol = "GEN";
        string memory contractURI = "ipfs://";
        string memory baseURI = "ipfs://"; // suffixed with /?hash=
        uint256 maxSupply = 256;
        instance = new Generative(initialOwner, name, symbol, contractURI, baseURI, maxSupply);
    }

    function testName() public {
        assertEq(instance.name(), "Generative");
    }
}
