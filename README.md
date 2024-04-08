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

We use OpenZeppelin contracts for the ERC-721 implementation.

```bash
forge install OpenZeppelin/openzeppelin-contracts@v5.0.1 --no-commit
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

To deploy fully with a verification 


```bash
source .env;
forge script script/BaseGen.s.sol:MyScript --rpc-url $RPC_URL --broadcast --verify -vvvv
```

> [!IMPORTANT]
> You need to have a `.env` file with the `RPC_URL` variable set.
> Do not forget to obtain ehterscan or basescan API key and set it in the `.env` file.

* https://book.getfoundry.sh/tutorials/solidity-scripting

See [Solidity scripting guide](https://book.getfoundry.sh/tutorials/solidity-scripting) for more information.

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