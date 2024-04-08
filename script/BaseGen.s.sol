// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
// import "forge-std/console2.sol";
import "../src/BaseGen.sol";

contract MyScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        address initialOwner = vm.addr(deployerPrivateKey);
        string memory name = "Vortices";
        string memory symbol = "VTX";
        string memory contractURI = "ipfs://bafkreicthpidyo3gznp3uuezvweiur7xcbo5qcwgw3x4teui2psoqxxbgq";
        string memory baseURI = "https://dyndata.deno.dev/base/content/"; // suffixed with /?hash=
        uint256 maxSupply = 128;

        BaseGen nft = new BaseGen(initialOwner, name, symbol, contractURI, baseURI, maxSupply);
        // console.log("Contract deployed to %s", address(nft));

        vm.stopBroadcast();
    }
}
