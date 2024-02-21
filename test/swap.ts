import {
    time,
    loadFixture,
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";
  import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
  import { expect, assert } from "chai";
  import { ethers } from "hardhat";
  
  
  describe("Swapping Contract Test", function () {
    async function deploy(){
        const [account1, account2, account3] = await ethers.getSigners();

        const TokenA = await ethers.getContractFactory("TokenA");
        const tokenA = await TokenA.deploy(account1.address);

        const TokenB = await ethers.getContractFactory("TokenB");
        const tokenB = await TokenB.deploy(account1.address);

        const Swap = await ethers.getContractFactory("Swap");
        const chargesPercentage = 5;
        const defaultCharges = 1;

        const swap = await Swap.deploy(tokenA.target, tokenB.target, chargesPercentage, defaultCharges);

        const tokenAmount = 100;
        const amounToFundContract= 1000;

        const tx1= await tokenA.transfer(swap.target, amounToFundContract); // fund contract with tokenA 
        tx1.wait()
      
        const tx2= await tokenB.transfer(swap.target, amounToFundContract); // fund contract with tokenB
        tx2.wait();
       
        const tx3= await tokenA.transfer(account2.address, tokenAmount); // fund account2 with tokenA
        tx3.wait()
      
        const tx4= await tokenB.transfer(account3.address, tokenAmount); // fund account3 with tokenB
        tx4.wait();
        
        return { tokenA, tokenB, swap, account1, account2, account3, tokenAmount, amounToFundContract };
    };

    async function approveTokenA(account: any, address: any, amount: any){
        const { tokenA } = await loadFixture(deploy);
        const addressSigner= await ethers.getSigner(account.address);
        await tokenA.connect(addressSigner).approve(address, amount);
      };

      async function approveTokenB(account: any, address: any, amount: any){
        const { tokenB } = await loadFixture(deploy);
        const addressSigner= await ethers.getSigner(account.address);
        await tokenB.connect(addressSigner).approve(address, amount);
      };

    describe("Contract", async () => {
        it("contract get funded with tokenA and tokenB", async () => {
            const { tokenA, tokenB, swap, amounToFundContract } = await loadFixture(deploy);

            const balanceA= await tokenA.balanceOf(swap.target);
            const balanceB= await tokenB.balanceOf(swap.target);

            expect(balanceA).to.be.equal(amounToFundContract);
            expect(balanceB).to.be.equal(amounToFundContract);
        });

        it("address 2 get funded with tokenA", async () => {
            const { tokenA, account2, tokenAmount} = await loadFixture(deploy);

            const balance= await tokenA.balanceOf(account2.address);

            expect(balance).to.be.equal(tokenAmount);
            
        });

        it("address 3 get funded with tokenB", async () => {
            const { tokenB, account3, tokenAmount} = await loadFixture(deploy);

            const balance= await tokenB.balanceOf(account3.address);

            expect(balance).to.be.equal(tokenAmount);
            
        });

        it("can swap tokenA for tokenB successfully", async () => {
            const { tokenB, tokenA, swap, account2, tokenAmount} = await loadFixture(deploy);

            const balanceB= await tokenB.balanceOf(account2.address);
            expect(balanceB).to.be.equal(0);

            const amountToSwap= 20;
            const charges= await swap.calculateCharges(amountToSwap)
            const amountPlusCharges= amountToSwap + Number(charges)

            const address2Signer= await ethers.getSigner(account2.address)
            await tokenA.connect(address2Signer).approve(swap.target, amountPlusCharges);
            const tx= await swap.connect(address2Signer).swapAforB(amountToSwap);
            tx.wait()

            const newBalanceA= await tokenA.balanceOf(account2.address)
            const newBalanceB= await tokenB.balanceOf(account2.address)

            expect(newBalanceA).to.be.equal(tokenAmount-amountPlusCharges)
            expect(newBalanceB).to.be.equal(amountToSwap)
        });

        it("can swap tokenB for tokenA successfully", async () => {
            const { tokenB, tokenA, swap, account3, tokenAmount} = await loadFixture(deploy);

            const balanceA= await tokenA.balanceOf(account3.address);
            expect(balanceA).to.be.equal(0);

            const amountToSwap= 20;
            const charges= await swap.calculateCharges(amountToSwap)
            const amountPlusCharges= amountToSwap + Number(charges)

            const address3Signer= await ethers.getSigner(account3.address)
            await tokenB.connect(address3Signer).approve(swap.target, amountPlusCharges);
            const tx= await swap.connect(address3Signer).swapBforA(amountToSwap);
            tx.wait()

            const newBalanceA= await tokenA.balanceOf(account3.address)
            const newBalanceB= await tokenB.balanceOf(account3.address)

            expect(newBalanceB).to.be.equal(tokenAmount-amountPlusCharges)
            expect(newBalanceA).to.be.equal(amountToSwap)
        });  
    })     
           
  });

