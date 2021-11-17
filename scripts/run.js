const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractFactory.deploy(
    ["Haland", "Mbappe", "Salah"], // Names
    ["QmZGp5n319GzGoqj8s5i57EWGni3119ZTBpbPVPrDHyNdQ", // Images
    "QmUf7obvfandnYoCcoWs8ovSoFLGLJBYfSrRsbvYxKgkef", 
    "QmRPPRngqV1bUb1r88SS5S6VcGpatSGwEB3ic1vBRr2vx5"],
    [200, 400, 600], // HP values
    [200, 100, 50], // Attack damage
    "Angry Pep", // Boss Name
    "ipfs://QmeuqxMiJpk3guV6fv4wzbRiQAadnNP5tDYuZkU3W4gZGz", // Boss Image
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

  console.log("Done!")

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