// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BaseGen.sol";

contract BaseGenTest is Test {
    BaseGen public instance;

    function setUp() public {
        address initialOwner = vm.addr(1);
        string memory name = "Generative";
        string memory symbol = "GEN";
        string memory contractURI = "ipfs://";
        string memory baseURI = "https://data.kodadot.xyz/base/"; // suffixed with /?hash=
        uint256 maxSupply = 256;
        instance = new BaseGen(initialOwner, name, symbol, contractURI, baseURI, maxSupply);
        // instance.safeMint(initialOwner);
        instance.safeMint{value: 0.01 ether}(initialOwner);
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

        assertEq(instance.tokenURI(0), string.concat(expected, "0"));
    }
}
