// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Generative is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;

    constructor(address initialOwner, string memory name_, string memory symbol_)
        ERC721(name_, symbol_)
        Ownable(initialOwner)
    {}

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        string memory name = name();
        string memory json = string(
            abi.encodePacked(
                '{"name": "',
                name,
                " #",
                Strings.toString(tokenId),
                '", "description": "',
                name,
                ' is a generative collection minted by KodaDot.xyz", "image": "',
                baseURI,
                Strings.toString(tokenId),
                '", "attributes": []}'
            )
        );
        return json;
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
