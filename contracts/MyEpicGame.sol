// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions provided by OpenZepplin.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

// inherit OpenZeppelin contract using 'is ERC721' when contract is declared
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

    // initialize two state variables which act like permanent global variables on the contract.
    // nftHolderAttributes will store the state of the palyers NFTs
    // map the NFTs id to a CharacterAttributes struct
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;
    // nftHolders maps the address of a user to the ID of the NFT they own.
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
        // Why? good solution if you want to avoid 0's
        _tokenIds.increment();
    }

    // mintCharacterNFt is where the minting takes place
    // mintCharacterNFT takes in _characterIndex as an argument, why?
    // Players need to be able to tell the contract which character they want.
    function mintCharacterNFT(uint256 _characterIndex) external {
        // newItemId stores the id of the NFT
        // * Each NFT is unique, that uniqueness is achieved by giving
        // each token a unique ID... aka a basic counter.
        // _tokenIds.current() returns 1 since we incremented from zero in the constructor
        uint256 newItemId = _tokenIds.current();

        // Magical function!
        // Assigns the tokenId to the caller's wallet address.
        // Basically translates to: "mint the NFT with id newItemId to the user
        // with address msg.sender".
        // msg.sender is a variable solidity provides that easily gives us access
        // to the public address of the person calling the contract
        // This is a SUPER SECURE way to get the users public address
        // Since public addresses are "public" msg.sender is the most secure way to access that address
        _safeMint(msg.sender, newItemId);

        // nftHolderAttributes maps the tokenId of the NFT to a struct of CharacterAttributes
        // This enables easy value updates related to the Players NFT.
        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].hp,
            attackDamage: defaultCharacters[_characterIndex].attackDamage
        });

        console.log(
            "Minted NFT w/ tokenId %s and characterIndex %s",
            newItemId,
            _characterIndex
        );

        // map the users public wallet address to the NFTs tokenID.
        // Will help keep track of who owns which NFTs.
        nftHolders[msg.sender] = newItemId;

        // After the NFt is minted, increment tokenIds using .increment() from OpenZepplin
        // Ensures that the next time an NFT is minted, it'll have a diffenet tokenIds.
        _tokenIds.increment();
    }
}
