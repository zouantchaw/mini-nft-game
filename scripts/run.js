const main = async () => {
  // compiles MyEpicGame contract and generates the necessary files needed to work w/ contract
  // under the 'artifacts' directory
  const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame')

  // Hardhat creates a local Ethereum network, just for this project.
  // After script completes, it'll destroy that local network. That means
  // every time you run the contract, it'll be a fresh blockchain.
  // Its almost like refreshing your local server every time so you start from a clean slate.
  const gameContract = await gameContractFactory.deploy();

  // Waits for the contract to be mined and deployed to our local blockchain
  // Hardhat creates fake "miners" on our machine, to try its best to imitate the actual blockchain
  // constructor runs when contract is fully deployed
  await gameContract.deployed();

  // once deployed, gameContract.address gives us the address of the deployed contract
  // This address is how you find the contract on the blockchain.
  // Since we are deploying this contract on a local blockchain, only this contract will be on that blockchain
  console.log("Contract deployed to:", gameContract.address);
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1)
  }
};

runMain();