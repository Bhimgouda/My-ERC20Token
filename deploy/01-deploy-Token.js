const {network, ethers} = require("hardhat");
const {developmentChains, networkConfig} = require("../helper-hardhat.config")
const {verify} = require("../utils/verify")

const TOKEN_NAME = process.env.TOKEN_NAME
const TOKEN_SYMBOL = process.env.TOKEN_SYMBOL
const TOKEN_SUPPLY = process.env.TOKEN_SUPPLY

// hre = hardhat runtime environment gives all this arguments to deploy scripts

module.exports = async ({getNamedAccounts, deployments}) => {
    const {deploy, log, get} = deployments
    const {deployer} = await getNamedAccounts()
    const {name: networkName} = network;


    if(developmentChains.includes(networkName)){
        // Logic when deploying on dev chains
        // To deploy mocks and all
    }

    const args = [TOKEN_NAME, TOKEN_SYMBOL, ethers.utils.parseEther(TOKEN_SUPPLY)]

    // Deploy
    const fundMe = await deploy("BhimToken", {
        from: deployer,
        args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1
    })

    log("---------------------------------------------")

    // Auto Verification of deployed smart contracts on mainnets and testnets
    if(!developmentChains.includes(networkName)){
        await verify(fundMe.address, args);
    }
}
