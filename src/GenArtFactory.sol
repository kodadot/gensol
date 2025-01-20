// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/Clones.sol";

import "./BaseGen.sol";

contract GenArtFactory {
    address public baseGen;
    uint256 private _mintPrice = 0.0015 ether;

    constructor(address _baseGen) {
        baseGen = _baseGen;
    }

    function createGenArt(
        address initialOwner,
        string memory name,
        string memory symbol,
        string memory contractURI,
        string memory baseURI,
        uint256 maxSupply,
        address receiver
    ) external returns (address) {
        address clone = Clones.clone(baseGen);
        BaseGen(clone).initialize(
            initialOwner,
            name,
            symbol,
            contractURI,
            baseURI,
            maxSupply,
            receiver,
            _mintPrice
        );
        return clone;
    }
}