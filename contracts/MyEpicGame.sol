// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions provided by OpenZepplin.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

// inherirts from ERC721: standard NFT contract!
contract MyEpicGame is ERC721 {
    // Define a new type(struct) with 6 fields
    struct CharacterAttributes {
        uint256 characterIndex;
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    // Attach library functions from Counters to Counters.Counter
    // The tokenId is the NFTs unique identifier
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Create an array that will hold the default character data
    // Help for after minting when you want to know things like HP, AD, etc
    CharacterAttributes[] defaultCharacters;

    // Create a mapping from the nft's tokenId => that NFTs attributes
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

    // Create a mapping from an address => the NFTs tokenId.
    // Stores the owner of the NFT so it can be refrenced later.
    mapping(address => uint256) public nftHolders;

    // constructor that holds data to be passed into contract at initialization
    // These values get passed in from run.js
    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDmg
    ) ERC721("Jogas", "JOGA") {
        // Loop through all the characters, and save their values in the contract so
        // we can use them later when we mint our NFTs.
        for (uint256 i = 0; i < characterNames.length; i += 1) {
            defaultCharacters.push(
                CharacterAttributes({
                    characterIndex: i,
                    name: characterNames[i],
                    imageURI: characterImageURIs[i],
                    hp: characterHp[i],
                    maxHp: characterHp[i],
                    attackDamage: characterAttackDmg[i]
                })
            );

            CharacterAttributes memory c = defaultCharacters[i];
            console.log(
                "Done initilaiazing %s w/ HP %s, img %s",
                c.name,
                c.hp,
                c.imageURI
            );
        }

        // Increment tokenIds so that the first NFT has an ID of 1.
        _tokenIds.increment();
    }
}
