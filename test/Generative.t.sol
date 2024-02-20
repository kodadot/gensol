// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

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
        // address operatorAllowlist = address(bytes20(bytes("0x6b969FD89dE634d8DE3271EbE97734FEFfcd58eE"))); // testnet
        // address operatorAllowlistMain = "0x5F5EBa8133f68ea22D712b0926e2803E78D89221"; // mainnet
        address operatorAllowlist = address(0);
        uint256 maxSupply = 256;
        instance = new Generative(initialOwner, name, symbol, contractURI, baseURI, operatorAllowlist, maxSupply);
    }

    function testName() public {
        assertEq(instance.name(), "Generative");
    }
}
