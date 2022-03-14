const Config = require("../vrf.config.js");

async function deploy() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying RNGVRF with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const RNGVRF = await ethers.getContractFactory("RNGVRF");
    const instance = await RNGVRF.deploy(Config.coordinator, Config.keyHash, Config.fee);

    console.log("RNGVRF address:", instance.address);
}

deploy()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
