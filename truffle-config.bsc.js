const HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config();

const mnemonic = process.env.MNEMONIC;

module.exports = {
  contracts_build_directory: './build/contracts',

  contracts_directory: './contracts',

  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },
    bscTestnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://data-seed-prebsc-2-s1.binance.org:8545/`),
      network_id: 97,
      gas: 5500000, // Or any other gas value you need
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    bscMainnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://bsc-dataseed.binance.org/`),
      network_id: 56,
      gas: 5500000, // Or any other gas value you need
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    }
  },

  mocha: {
    timeout: 100000
  },

  compilers: {
    solc: {
      version: "^0.8.7",
    }
  },
  db: {
    enabled: false
  }
};
