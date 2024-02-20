import {
    time,
    loadFixture,
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";
  import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
  import { expect, assert } from "chai";
  import { ethers } from "hardhat";
  
  
  describe("Swapping Contract Test", function () {
    async function deploySave(){
      const TokenA = await ethers.getContractFactory("TokenA");
      const tokenA = await TokenA.deploy();

      const TokenB = await ethers.getContractFactory("TokenB");
      const tokenB = await TokenB.deploy();

      const Swap = await ethers.getContractFactory("Swap");
      const swap = await Swap.deploy(tokenA.target, tokenB.target, 2, 5);


      const [account1, account2] = await ethers.getSigners();
      const tokenAAmount = 100;
      const tokenBAmount = 200;
      return { tokenA, tokenB, swap, account1, account2, tokenAAmount, tokenBAmount };
    };

    async function fundContract(amount: any){
      const { tokenA, tokenB, swap } = await loadFixture(deploySave);
      await tokenA.transfer(swap.target, amount);
      await tokenB.transfer(swap.target, amount);
    };
  
  
    describe("Contract", async () => {
        it("swap token A for B successfully", async () => {
            const { tokenA, tokenB, swap, account1, tokenAAmount} = await loadFixture(deploySave);
            await fundContract(10000) 
        });
    })     
           
  });

