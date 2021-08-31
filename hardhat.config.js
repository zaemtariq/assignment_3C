require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
const ROPSTEN_PRIVATE_KEY = "c40df1bffefea64f691ff145e47afc1604561f90de3e83ff4484e314a8b40fa9";

module.exports = {
  solidity: "0.8.0",
  networks: {
    ropsten: {
      url: `https://ropsten.infura.io/v3/70d3232596d04f608335f4ec1e72f81e`,
      accounts: [`0x${ROPSTEN_PRIVATE_KEY}`],
    },
  },

};