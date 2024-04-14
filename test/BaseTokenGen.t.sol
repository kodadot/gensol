// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/BaseTokenGen.sol";
import "../src/Token.sol";


contract BaseTokenGenTest is Test {
    BaseTokenGen public instance;
    Token public token;

    function setUp() public {
        // address initialOwner = vm.addr(1);
        address next = vm.addr(2);
        string memory name = "Generative";
        string memory symbol = "GEN";
        string memory contractURI = "ipfs://";
        string memory baseURI = "https://data.kodadot.xyz/base/"; // suffixed with /?hash=
        uint256 maxSupply = 256;
        token = new Token("Token", "TKN");
        address tokenAddress = address(token);
        instance = new BaseTokenGen(next, name, symbol, contractURI, baseURI, maxSupply, tokenAddress);
        token.approve(address(instance), 11 * 1e18);
        instance.safeMint(next);
        console2.log("Token deployed to %s", address(token));
        // instance.safeMint{value: 0.01 ether}(initialOwner);
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

    function testTokenSent() public view {
        address next = vm.addr(2);
        assertEq(token.balanceOf(next), 11 ether);
    }

    function testTokenReceived() public view {
        address next = vm.addr(2);
        assertEq(instance.balanceOf(next), 1);
    }
}
