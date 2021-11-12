const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractFactory.deploy(
    ["Mendy", "Mbappe", "Salah"], // Names
    ["assets/mendyInGoal.jpg", // Images
    "assets/mbappeShooting.jpg", 
    "assets/salahShooting.jpg"],
    [200, 400, 600], // HP values
    [200, 100, 50], // Attack damage
    "Angry Pep", // Boss Name
    "assets/angryPep.jpg", // Boss Image
    10000, // Boss hp
    50 // Boss attack damage
  );

  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
}

runMain()