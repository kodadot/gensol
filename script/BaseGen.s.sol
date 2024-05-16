// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/BaseGen.sol";

contract MyScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        address initialOwner = vm.addr(deployerPrivateKey);
        string memory name = "Koda.";
        string memory symbol = "KODA";
        string memory contractURI = "ipfs://bafkreige4zmihk32by3n5aeoq7svlqeyhoaapt4l7hoyspsnr2hm7ljjgq";
        string memory baseURI = "https://dyndata.deno.dev/base/content/"; 
        uint256 maxSupply = 64;
        address receiver = 0xE844b2a0a6453250c920BD2b4B7741946aB16C08;

        BaseGen nft = new BaseGen(initialOwner, name, symbol, contractURI, baseURI, maxSupply, receiver);
        console2.log("Contract deployed to %s", address(nft));

        vm.stopBroadcast();
    }
}
