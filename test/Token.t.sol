// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/Token.sol";


contract TokenTest is Test {
    Token public token;

    function setUp() public {
        token = new Token("Token", "TKN");
        console2.log("Token deployed to %s", address(token));
        // Token deployed to 0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f
    }

    function testAddressIsDifferent() public view {
        address tokenAddr = address(bytes20(bytes("0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f")));
        assertNotEq(address(token), tokenAddr);
    }

    function testAddressTheSame() public view {
        address tokenAddr = address(uint160(0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f));
        assertEq(address(token), tokenAddr);
    }

}
