// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "./lib/GenStrings.sol";

contract Generative is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;
    string private _contractURI;
    string private _generatorURI;
    uint256 private _maxSupply;

    mapping(uint256 tokenId => string) private _tokenURIs;

    event ContractURIUpdated(string newContractURI);
    // https://github.com/ProjectOpenSea/seadrop/blob/main/src/ERC721ContractMetadata.sol
    event MaxSupplyUpdated(uint256 newMaxSupply);

    // https://github.com/ProjectOpenSea/seadrop/blob/main/src/lib/ERC721SeaDropStructsErrorsAndEvents.sol
    error MintQuantityExceedsMaxSupply(uint256 tokenId, uint256 maxSupply);

    constructor(
        address initialOwner,
        string memory name_,
        string memory symbol_,
        string memory contractURI_,
        string memory baseURI_,
        uint256 maxSupply_
    ) ERC721(name_, symbol_) Ownable(initialOwner) {
        // setContractURI(contractURI_);
        // setMaxSupply(maxSupply_);
        _generatorURI = baseURI_;
        _contractURI = contractURI_;
        _maxSupply = maxSupply_;
    }

    function _baseURI() internal view override returns (string memory) {
        return _generatorURI;
    }

    // or e.g. "https://external-link-url.com/my-contract-metadata.json";

    function contractURI() external view returns (string memory) {
        return _contractURI;
        // or e.g. for onchain:
        // string memory json = '{"name": "Creatures","description":"..."}';
        // return string.concat("data:application/json;utf8,", json);
    }

    /// @dev Suggested setter, not explicitly specified as part of this ERC
    function setContractURI(string memory newURI) external onlyOwner {
        _contractURI = newURI;
        emit ContractURIUpdated(newURI);
    }

    /**
     * @notice Sets the max token supply and emits an event.
     *
     * @param newMaxSupply The new max supply to set.
     */
    function setMaxSupply(uint256 newMaxSupply) external onlyOwner {
        // Ensure the sender is only the owner or contract itself.
        _maxSupply = newMaxSupply;

        emit MaxSupplyUpdated(newMaxSupply);
    }

    // function safeMint(address to, string memory uri) public onlyOwner {
    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _nextTokenId++;

        if (tokenId > _maxSupply) {
            revert MintQuantityExceedsMaxSupply(tokenId, _maxSupply);
        }

        _safeMint(to, tokenId);
        // URI should be random hash generated from address to + tokenId + block.timestamp
        string memory realURI = GenStrings.toHexString(keccak256(abi.encodePacked(to, tokenId, block.timestamp)));
        _setTokenURI(tokenId, realURI);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        _requireOwned(tokenId);

        // string memory baseURI = _baseURI();
        // since ERC721URIStorage is the right most parent contract with function tokenURI()
        string memory URI = super.tokenURI(tokenId);
        /// @dev cannot access _tokenURIs directly will need workaround
        // string memory _tokenURI = _tokenURIs[tokenId];
        string memory name = string.concat(name(), " #", Strings.toString(tokenId));
        string memory link = "kodadot.xyz";
        string memory description = string.concat(name, " is a generative EVM art by ", link);
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                name,
                '", "description": "',
                description,
                '", "animation_url": "',
                URI,
                '", "image": "',
                URI,
                '", "attributes": []}'
            )
        );

        string memory output = string(abi.encodePacked("data:application/json;base64,", json));
        return output;
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
