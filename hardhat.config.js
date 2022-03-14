require("@nomiclabs/hardhat-ethers");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "kcc_testnet",
  networks: {
    kcc_mainnet: {
      url: "https://rpc-mainnet.kcc.network",
      accounts: ["48d5f9ce288681f8f569f15fc013c2cf7e114fb2448540ffbed2862c8de44205"],
    },
    kcc_testnet: {
      url: "https://rpc-testnet.kcc.network",
      accounts: ["48d5f9ce288681f8f569f15fc013c2cf7e114fb2448540ffbed2862c8de44205"],
    }
  },
  solidity: "0.8.0",
};
