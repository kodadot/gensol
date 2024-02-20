# GenSOL

GenSOL is a ERC-721 contract for generative art.
Written in Solidity, it is designed to be used with the Foundry framework.

## Features

* On-chain metadata (base64 encoded JSON)
* Ability to set maximum supply
* Art is generated from **account + token ID + block number**
* Contract URI

## Development

> [!IMPORTANT]  
> Last time I wrote a smart contract was in 2019. I am still learning new things in Solidity and code looks like a mess. I am open to any suggestions and improvements.

### Prerequisites

* [Foundry](https://book.getfoundry.sh/getting-started/installation)

### Libraries

We use [Immutable contracts](https://github.com/immutable/contracts) for the ERC-721 implementation.

```bash
forge install immutable-contracts=immutable/contracts@v2.2.3 --no-commit
```

They work only with [Solidity 0.8.19](https://docs.immutable.com/docs/zkevm/architecture/chain-differences/#evm-differences), So usable version of OpenZeppelin is `v4.9.3` latest is `v5.0.1`.

```bash
forge install OpenZeppelin/openzeppelin-contracts@v4.9.3 --no-commit
```

### Testing the contract

```bash
forge test
```

### Deploying the contract

You can simulate a deployment by running the script:

```bash
forge script script/Generative.s.sol
```

* https://book.getfoundry.sh/tutorials/solidity-scripting

See [Solidity scripting guide](https://book.getfoundry.sh/tutorials/solidity-scripting) for more information.

* https://docs.immutable.com/docs/zkEVM/deploy-contracts/deploy#add-contract

## Dev hacks

### Add library as a submodule

```bash
git submodule add <ssh_url_of_repo> lib/<name_of_the_lib>
```

## Reading and resources

### Reading

* https://blog.chain.link/how-to-create-generative-art-nfts/ 
* https://fullyonchain.xyz 
* https://brotchain.art/color-editor.html 
* https://github.com/ArtBlocks/artblocks-starter-template 
* https://blog.thirdweb.com/guides/create-a-generative-art-nft-collection-using-solidity-javascript/ 
* https://medium.com/coinmonks/creating-generative-art-nfts-with-python-solidity-a95eaeea515e 


* https://eips.ethereum.org/EIPS/eip-7572 
* https://eips.ethereum.org/EIPS/eip-7496 
* https://eips.ethereum.org/EIPS/eip-4906 

* https://medium.com/quick-programming/how-to-implement-fully-on-chain-nft-contracts-8c409acc98b7 

* https://docs.alchemy.com/docs/how-to-make-nfts-with-on-chain-metadata-hardhat-and-javascript
* https://miningclub.medium.com/how-we-moved-nft-metadata-off-ipfs-and-into-the-smart-contract-59b5db822322
* https://stackoverflow.com/questions/71626871/why-is-my-nft-metadata-not-showing-on-opensea
* https://medium.com/coinmonks/how-to-create-on-chain-nfts-with-solidity-1e20ff9dd87e
* https://forum.openzeppelin.com/t/onchain-nft-metadata-not-json-structure-tokenuri-is-not-showing-up-on-opensea/34932
* https://ethereum.stackexchange.com/questions/124874/nft-metatdata-not-showing-on-opensea
* https://www.reddit.com/r/ethdev/comments/v13sk1/how_to_store_metadata_on_nfts_on_chain_and_how/
* https://www.kevfoo.com/2022/05/opensea-contracturi/