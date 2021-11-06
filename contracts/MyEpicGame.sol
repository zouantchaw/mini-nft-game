// SPDX-License-Identifier: UNLICENSED

// specifies that the source code is written for Solidity version 0.8.0
// insures that the contract is not compatible with a new(breaking) compiler version,
// were it could behave different.

// pragma keyword is used to enable certain compiler features or checks
// a pragma directive is always local to a source file, so you have to add them to all your files
// if you want to enable it in your whole project
pragma solidity ^0.8.0;

// similiar to JS, solidity supports import statement to help modularise you code
// using Hardhat to do some console logs in our contract
import "hardhat/console.sol";

// in Solidity, contracts are a collection of code(its functions) and data(its state) that ressides
// at a specific address on the Ethereum blockchain
contract MyEpicGame {
  constructor() {
    console.log("This is my game contract");
  }
}

