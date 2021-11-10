const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractFactory.deploy(
    ["Mendy", "Mbappe", "Salah"], // Names
    ["https://drive.google.com/file/d/1JVcdhyOzGFMRiL7-6RObrDcJ25YXyjdH/view?usp=sharing", // Images
    "https://drive.google.com/file/d/1rUEKlO434D3OIxY1o6djMpArS-64RWX9/view?usp=sharing", 
    "https://drive.google.com/file/d/1rUEKlO434D3OIxY1o6djMpArS-64RWX9/view?usp=sharing"],
    [200, 400, 600], // HP values
    [200, 100, 50], // Attack damage
    "Angry Pep", // Boss Name
    "https://drive.google.com/file/d/1Q_1W2ZyuFkpgkNW5K9S1gEi-wtIlsQ03/view?usp=sharing", // Boss Image
    10000, // Boss hp
    50 // Boss attack damage
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

  let txn;
  txn = await gameContract.mintCharacterNFT(2);
  await txn.wait()

  txn = await gameContract.attackBoss();
  await txn.wait();
  
  txn = await gameContract.attackBoss();
  await txn.wait();

  // Get the value of the NFTs URI.
  // tokenUri is a function on every NFT that return actual data attached to the NFT.
  let returnedTokenUri = await gameContract.tokenURI(1);
  console.log("Token URI:", returnedTokenUri)
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