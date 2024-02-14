// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Generative.sol";

contract GenerativeTest is Test {
  Generative public instance;

  function setUp() public {
    address initialOwner = vm.addr(1);
    instance = new Generative(initialOwner);
  }

  function testName() public {
    assertEq(instance.name(), "Generative");
  }
}
