// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/lib/GenStrings.sol";

contract GenStringsTest is Test {
    function testHexString() public pure {
        address owner = vm.addr(1);
        uint256 tokenId = 1;
        bytes32 tokenHash = keccak256(abi.encodePacked(owner, tokenId));
        string memory realURI = GenStrings.toHexString(tokenHash);
        console2.logString(realURI);
        assertEq(realURI, "0x81b4a33eff5aca08405e0c1d707d85865470ae71084bfde64620c7e4d4093e78");
    }
}
