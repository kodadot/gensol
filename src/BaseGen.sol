// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract BaseGen is ERC721, ERC721Burnable, ERC721Royalty, Ownable {
    uint256 private _nextTokenId;
    string private _contractURI;
    string private _generatorURI;
    uint256 private _maxSupply;
    address private _receiver;
    uint256 private _mintPrice = 0.0015 ether;

    mapping(uint256 tokenId => string) private _tokenURIs;

    event ContractURIUpdated(string newContractURI);
    // https://github.com/ProjectOpenSea/seadrop/blob/main/src/ERC721ContractMetadata.sol
    event MaxSupplyUpdated(uint256 newMaxSupply);

    // https://github.com/ProjectOpenSea/seadrop/blob/main/src/lib/ERC721SeaDropStructsErrorsAndEvents.sol
    error MintQuantityExceedsMaxSupply(uint256 tokenId, uint256 maxSupply);

    error InsufficientFunds(uint256 expected, uint256 value);

    // https://github.com/ProjectOpenSea/seadrop/blob/main/src/interfaces/ISeaDropTokenContractMetadata.sol
    error NewMaxSupplyCannotBeLessThenTotalMinted(uint256 newSupply, uint256 totalMinted);

    error MintQuantityCannotBeZero();

    constructor(
        address initialOwner,
        string memory name_,
        string memory symbol_,
        string memory contractURI_,
        string memory baseURI_,
        uint256 maxSupply_,
        address receiver_
    ) ERC721(name_, symbol_) Ownable(initialOwner) {
        // setContractURI(contractURI_);
        // setMaxSupply(maxSupply_);
        _generatorURI = string.concat(baseURI_, Strings.toHexString(uint160(address(this)), 20), "/");
        _contractURI = contractURI_;
        _maxSupply = maxSupply_;
        _receiver = receiver_;
        _setDefaultRoyalty(receiver_, 5e2); // 
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
        if (newMaxSupply < _nextTokenId) {
            revert MintQuantityExceedsMaxSupply(newMaxSupply, _nextTokenId);
        }

        _maxSupply = newMaxSupply;

        emit MaxSupplyUpdated(newMaxSupply);
    }

    /**
     * @dev Returns the approximate value of tokens in existence.
     * does not include burned tokens.
     */
    //  https://github.com/ProjectOpenSea/seadrop/blob/main/src/clones/ERC721ACloneable.sol
    function totalSupply() public view returns (uint256) {
        return _nextTokenId;
    }

    /**
     * @notice Returns the max token supply.
    */
    function maxSupply() public view returns (uint256) {
        return _maxSupply;
    }

    // function transferOwnership(address newOwner) public override(Ownable) onlyOwner {
    //     super.transferOwnership(newOwner);
    //     _setDefaultRoyalty(newOwner, 5e2);
    // }

    // function safeMint(address to, string memory uri) public onlyOwner {
    function safeMint(address to) public payable {
        uint256 tokenId = _nextTokenId++;

        if (tokenId >= _maxSupply) {
            revert MintQuantityExceedsMaxSupply(tokenId, _maxSupply);
        }

        if (msg.value < _mintPrice) {
            revert InsufficientFunds(_mintPrice, msg.value);
        }

        _splitPayment(msg.value);

        _safeMint(to, tokenId);
        // URI should be random hash generated from address to + tokenId + block.timestamp
        // string memory realURI = GenStrings.toHexString(keccak256(abi.encodePacked(to, tokenId, block.timestamp)));
        // _setTokenURI(tokenId, realURI);
    }

    function safeBatchMint(address to, uint256 quantity) public payable {
        if (quantity == 0) {
            revert MintQuantityCannotBeZero();
        }

        uint256 tokenId = _nextTokenId;  // Local variable to reduce storage reads
        uint256 newTokenId = tokenId + quantity;

        if (newTokenId >= _maxSupply) {
            revert MintQuantityExceedsMaxSupply(_nextTokenId, _maxSupply);
        }

        uint256 totalCost = _mintPrice * quantity;

        if (msg.value < totalCost) {
            revert InsufficientFunds(totalCost, msg.value);
        }

        _splitPayment(totalCost);

        for (uint256 i = 0; i < quantity; i++) {
            _safeMint(to, tokenId++);
        }
        
        _nextTokenId = tokenId;
    }

    function _splitPayment(uint256 amount) private {
        if (_receiver != address(0)) {
            uint256 splitAmount = amount / 2;
            payable(_receiver).transfer(splitAmount);
            payable(owner()).transfer(splitAmount);
        } else {
            payable(owner()).transfer(amount);
        }
    }

    function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Royalty) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
