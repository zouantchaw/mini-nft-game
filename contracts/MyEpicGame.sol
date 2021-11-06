// SPDX-License-Identifier: UNLICENSED

import "hardhat/console.sol";

contract MyEpicGame {
    // Define a new type(struct) with 6 fields
    struct CharacterAttributes {
        uint256 characterIndex;
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    // Create an array that will hold the default character data
    // Help for after minting when you want to know things like HP, AD, etc
    CharacterAttributes[] defaultCharacters;

    // constructor that holds data to be passed into contract at initialization
    // These values get passed in from run.js
    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory charcterHp,
        uint256[] memory characterAttackDmg
    ) {
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

            CharacterAttributes memory c = deafaultCharacters[i];
            console.log(
                "Done initilaiazing %s w/ HP %s, img %s",
                c.name,
                c.hp,
                c.imageURI
            );
        }
    }
}
