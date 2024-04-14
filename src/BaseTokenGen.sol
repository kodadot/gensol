// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BaseTokenGen is ERC721, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;
    string private _contractURI;
    string private _generatorURI;
    uint256 private _maxSupply;
    IERC20 public token;
    // DEV: since our token is 18 decimals, we need to multiply by 1e18 and mint price 11 tokens
    uint256 public pricePerMint = 11 ether; 
    
    mapping(uint256 tokenId => string) private _tokenURIs;

    event ContractURIUpdated(string newContractURI);
    // https://github.com/ProjectOpenSea/seadrop/blob/main/src/ERC721ContractMetadata.sol
    event MaxSupplyUpdated(uint256 newMaxSupply);

    // https://github.com/ProjectOpenSea/seadrop/blob/main/src/lib/ERC721SeaDropStructsErrorsAndEvents.sol
    error MintQuantityExceedsMaxSupply(uint256 tokenId, uint256 maxSupply);

    error InsufficientFunds(uint256 tokenId, uint256 value);

    constructor(
        address initialOwner,
        string memory name_,
        string memory symbol_,
        string memory contractURI_,
        string memory baseURI_,
        uint256 maxSupply_,
        address token_
    ) ERC721(name_, symbol_) Ownable(initialOwner) {
        // setContractURI(contractURI_);
        // setMaxSupply(maxSupply_);
        _generatorURI = string.concat(baseURI_, Strings.toHexString(uint160(address(this)), 20), "/");
        _contractURI = contractURI_;
        _maxSupply = maxSupply_;
        token = IERC20(token_);
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
    function safeMint(address to) public {
        uint256 tokenId = _nextTokenId++;

        if (tokenId > _maxSupply) {
            revert MintQuantityExceedsMaxSupply(tokenId, _maxSupply);
        }

        uint256 allowance = token.allowance(msg.sender, address(this));

        // check if msg value is greater than 0.001 eth
        // if (msg.value >= 0.001 ether) {
        //     payable(owner()).transfer(msg.value);
        // } else {
        //     revert InsufficientFunds(tokenId, msg.value);
        // }
        if (allowance >= pricePerMint) { 
            bool sent = token.transferFrom(msg.sender, owner(), pricePerMint);
            require(sent, "Token transfer failed");
        } else {
            revert InsufficientFunds(tokenId, allowance);
        }

        _safeMint(to, tokenId);
        // URI should be random hash generated from address to + tokenId + block.timestamp
        // string memory realURI = GenStrings.toHexString(keccak256(abi.encodePacked(to, tokenId, block.timestamp)));
        // _setTokenURI(tokenId, realURI);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
