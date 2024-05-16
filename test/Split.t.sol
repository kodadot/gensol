// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/lib/Split.sol";

contract SplitTest is Test {
    function testFortyPercent() public pure {
        uint256 value = 1 ether;
        uint256 amount = Split.calculateAmount(value, 40);
        assertEq(amount, 400000000000000000);
    }

    function testThirtyThreePercent() public pure {
        uint256 value = 1 ether;
        uint256 amount = Split.calculateAmount(value, 33);
        assertEq(amount, 330000000000000000);
    }

    function testZeroValue() public pure {
        uint256 value = 0 ether;
        uint256 amount = Split.calculateAmount(value, 33);
        assertEq(amount, 0);
    }

    function testZeroPercent() public pure {
        uint256 value = 1 ether;
        uint256 amount = Split.calculateAmount(value, 0);
        assertEq(amount, 0);
    }

        function testTwelvePercent() public pure {
        uint256 value = 1 ether;
        uint256 amount = Split.calculateAmount(value, 12);
        assertEq(amount, 120000000000000000);
    }
}
