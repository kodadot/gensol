// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/BaseTokenGen.sol";

contract MyScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        address initialOwner = vm.addr(deployerPrivateKey);
        string memory name = "HIGHER";
        string memory symbol = unicode"↑";
        string memory contractURI = "ipfs://bafkreickjpqtqulirvugyqupeogbvum2uqsrp5focif5427fd2fzgywo4u";
        string memory baseURI = "https://dyndata.deno.dev/base/content/";
        uint256 maxSupply = 256;
        // address token = address(bytes20(bytes("0x0578d8A44db98B23BF096A382e016e29a5Ce0ffe")));
        address token = address(uint160(0x0578d8A44db98B23BF096A382e016e29a5Ce0ffe));


        // string memory name = "LOWER";
        // string memory symbol = unicode"↓";
        // string memory contractURI = "ipfs://bafkreigr2wbixu4dk2v3xxrmtju6tchcosz2fqtwo64u3fqlfb7esxjy4u";
        // string memory baseURI = "https://dyndata.deno.dev/basedev/content/";
        // uint256 maxSupply = 256;
        // address token = address(uint160(0xcBAe5Aa4Ff18053E579EdFa53174236CbD71C0e6));

        BaseTokenGen nft = new BaseTokenGen(initialOwner, name, symbol, contractURI, baseURI, maxSupply, token);
        console2.log("Contract deployed to %s", address(nft));

        vm.stopBroadcast();
    }
}
