const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractFactory.deploy(
    ["Mendy", "Mbappe", "Salah"], // Names
    ["https://www.si.com/.image/ar_4:3%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTc2MzAzOTE2NTc1NjMwNTA5/edouard-mendy-chelsea-gk.jpghttps://i.imgur.com/pKd5Sdk.png", // Images
    "https://static.straitstimes.com.sg/s3fs-public/styles/article_pictrure_780x520_/public/articles/2021/06/29/af_mbappe_2906.jpg?itok=gTAQjEbU&timestamp=1624949805", 
    "https://img2.chinadaily.com.cn/images/201804/16/5ad3f9d6a3105cdce0a2e43a.jpeg"],
    [200, 400, 600], // HP values
    [200, 100, 50] // Attack damage
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

  let txn;
  txn = await gameContract.mintCharacterNFT(0);
  await txn.wait()
  console.log("Minted NFT #1");
  
  txn = await gameContract.mintCharacterNFT(1);
  await txn.wait()
  console.log("Minted NFT #2");

  txn = await gameContract.mintCharacterNFT(2);
  await txn.wait()
  console.log("Minted NFT #3");

  txn = await gameContract.mintCharacterNFT(1);
  await txn.wait()
  console.log("Minted NFT #4");

  console.log("Done deploying and minting")

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