const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractFactory.deploy(
    ["Mendy", "Mbappe", "Salah"], // Names
    ["https://i2-prod.football.london/chelsea-fc/news/article19156275.ece/ALTERNATES/s615/0_Edouard-Mendy.jpg", // Images
    "https://static.straitstimes.com.sg/s3fs-public/styles/article_pictrure_780x520_/public/articles/2021/06/29/af_mbappe_2906.jpg?itok=gTAQjEbU&timestamp=1624949805", 
    "https://img2.chinadaily.com.cn/images/201804/16/5ad3f9d6a3105cdce0a2e43a.jpeg"],
    [200, 400, 600], // HP values
    [200, 100, 50], // Attack damage
    "Angry Pep", // Boss Name
    "https://dynaimage.cdn.cnn.com/cnn/q_auto,h_600/https%3A%2F%2Fcdn.cnn.com%2Fcnnnext%2Fdam%2Fassets%2F151026214217-22-what-a-shot-1027.jpg", // Boss Image
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