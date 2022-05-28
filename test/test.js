const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BattleGame", function () {
  let addr1;
  let addr2;
  let BATTLEGAME;
  let battleGame;
  beforeEach(async() => {
    [addr1,addr2]= await ethers.getSigners();
     BATTLEGAME = await ethers.getContractFactory("BattleGame");
     battleGame = await BATTLEGAME.deploy();
     battleGame.deployed();
  });
  describe("Testing",function(){
    it('Should show a warrior statistics', async() => {
      await battleGame.mint();
      const _statistics=await battleGame.tokenIdtoStatistics(1);
      console.log('before training ',_statistics);
      await battleGame.train(1);
     
      const statistics=await battleGame.tokenIdtoStatistics(1);
      console.log(statistics)
      const level=await battleGame.getLevels(1);
      console.log(level)
    });
  })
});
