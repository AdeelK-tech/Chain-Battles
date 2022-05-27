require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");
module.exports = {
  solidity: "0.8.4",
  networks:{
    mumbai:{
    url:process.env.TESTNET_RPC,
    accounts:[process.env.PRIVATE_KEY]
    }
  },
  etherscan:{
    apiKey: process.env.POLYGON_SCAN_APIKEY
  }
};
