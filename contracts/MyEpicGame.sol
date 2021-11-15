// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions provided by OpenZepplin.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

import "./libraries/Base64.sol";

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

    // *Events are like webhooks that the client can listen to.
    // Event that fires when NFT is done minting for user
    event CharacterNFTMinted(
        address sender,
        uint256 tokenId,
        uint256 characterIndex
    );
    // Event that fires when boss is succesfully attacked
    // Returns the boss's new hp and the player's new hp
    event AttackComplete(uint256 newBossHp, uint256 newPlayerHp);

    // struct that holds the boss data
    struct BigBoss {
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }
    // bigBoss variable will hold the boss so it can be referenced in different functions.
    BigBoss public bigBoss;

    // constructor that holds data to be passed into contract at initialization
    // These values get passed in from run.js
    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDmg,
        string memory bossName,
        string memory bossImageURI,
        uint256 bossHp,
        uint256 bossAttackDamage
    ) ERC721("Futbol", "FUT") {
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

        // Initialize the boss. Save it to global 'bigBoss' state variable
        bigBoss = BigBoss({
            name: bossName,
            imageURI: bossImageURI,
            hp: bossHp,
            maxHp: bossHp,
            attackDamage: bossAttackDamage
        });

        console.log(
            "Done initializing boss %s w/ HP %s, img %s",
            bigBoss.name,
            bigBoss.hp,
            bigBoss.imageURI
        );

        // Increment tokenIds so that the first NFT has an ID of 1.
        // Why? good solution if you want to avoid 0's
        _tokenIds.increment();
    }

    function checkIfUserHasNFT()
        public
        view
        returns (CharacterAttributes memory)
    {
        // Get the tokenId of the user's character NFT
        uint256 userNftTokenId = nftHolders[msg.sender];
        // If the user has a tokenId in the map, return their character
        // Why need to check if userNftTokenId > 0 ?
        // Bc there's no way to check if a key in a map exists
        // This is solved by increasing '_tokenIds' in the constructor so that no one is allowed
        // to have tokenId 0.
        if (userNftTokenId > 0) {
            return nftHolderAttributes[userNftTokenId];
        } else {
            // Otherwise, return an empty character.
            CharacterAttributes memory emptyStruct;
            return emptyStruct;
        }
    }

    function getAllDefaultCharacters()
        public
        view
        returns (CharacterAttributes[] memory)
    {
        // Return all default characters
        return defaultCharacters;
    }

    function getBigBoss() public view returns (BigBoss memory) {
        return bigBoss;
    }

    function attackBoss() public {
        // 1. Get the state of the player's NFT.
        // Get the NFTs tokenId that players owns
        uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
        // Get the players attributes
        CharacterAttributes storage player = nftHolderAttributes[
            nftTokenIdOfPlayer
        ];
        console.log(
            "\nPlayer w/ character %s about to attack. Has %s HP abd %s AD",
            player.name,
            player.hp,
            player.attackDamage
        );
        console.log(
            "Boss %s has %s HP and %s AD",
            bigBoss.name,
            bigBoss.hp,
            bigBoss.attackDamage
        );

        // 2. Make sure the player has more than 0 HP.
        require(player.hp > 0, "Error: character must have HP to attack boss.");

        // 3. Make sure the boss has more than 0 HP.
        require(player.hp > 0, "Error: boss must have HP to attack boss.");

        // 4. Allow player to attack the boss.
        // Check if the boss will have its HP reduced to below 0 based on the players attack damage.
        // ex. if bigBoss.hp = 10 and player.attackDamage = 30 then we know boss will have its HP reduced below 0
        // which would ause an error!
        if (bigBoss.hp < player.attackDamage) {
            bigBoss.hp = 0;
        } else {
            // Otherwise, reduce the the boss's HP based on how much damage the player does.
            bigBoss.hp = bigBoss.hp - player.attackDamage;
        }

        // 5. Allow the boss to attack the player.
        // Check if he player will have its HP reduced to below 0 based on the players attack damage.
        if (player.hp < bigBoss.attackDamage) {
            player.hp = 0;
        } else {
            // Otherwise, reduce the players HP based on how much damage the player does.
            player.hp = player.hp - bigBoss.attackDamage;
        }

        console.log("Player attacked boss. New boss hp: %s", bigBoss.hp);
        console.log("Boss attacked player. New player hp: %s", player.hp);
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

        // Fire CharacterNFTMinted event when minting is complete
        emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        // retrieve specific NFTs data by querying for it using its _tokenId
        // ex. If i did tokenURI(256) it would return JSON data related to the 256th NFT(if it existed)
        CharacterAttributes memory charAttributes = nftHolderAttributes[
            _tokenId
        ];

        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strMaxHp = Strings.toString(charAttributes.maxHp);
        string memory strAttackDamage = Strings.toString(
            charAttributes.attackDamage
        );

        // Pack/Structure the data in 'json' variable
        // abi.encodePacked combines strings, enables us to modify attributes
        // Formats json file and then encodes it in Base64
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        charAttributes.name,
                        " -- NFT #: ",
                        Strings.toString(_tokenId),
                        '", "description": "This is an NFT that lets people play in the game Angry Pep!", "image": "',
                        charAttributes.imageURI,
                        '", "attributes": [ { "trait_type": "Health Points", "value": ',
                        strHp,
                        ', "max_value":',
                        strMaxHp,
                        '}, { "trait_type": "Attack Damage", "value": ',
                        strAttackDamage,
                        "} ]}"
                    )
                )
            )
        );

        string memory output = string(
            // Lets browser know how to read the encode string we're passing it.
            abi.encodePacked("data:application/json;base64,", json)
        );
        return output;
    }
}
