# Contracts for the Random Number Generator

The RNG implementation is powered by the Verifiable Random Function(VRF).

## Get Started

### Install Dependencies

The project is based on the `Hardhat` framework. Install hardhat and other packages by the command:

```bash
npm install
```

### Compile

```bash
npx hardhat compile
```

### Configure

Configure the VRF related params in `vrf.config.js`. Set to the coordinator on the `KCC Testnet` by default.

### Deploy

- `KCC Testnet`

```bash
npx hardhat run scripts/deploy.js
```

- `KCC Mainnet`

```bash
npx hardhat run --network kcc_mainnet scripts/deploy.js
```
