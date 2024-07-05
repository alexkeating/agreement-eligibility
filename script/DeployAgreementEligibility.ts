import { config as dotEnvConfig } from "dotenv";
import { Deployer } from "@matterlabs/hardhat-zksync-deploy";
import { Wallet, Contract } from "zksync-ethers";
import * as hre from "hardhat";

const AgreementEligibilityFactory = require("../artifacts-zk/src/AgreementEligibilityFactory.sol/AgreementEligibilityFactory.json");

// Before executing a real deployment, be sure to set these values as appropriate for the environment being deployed
// to. The values used in the script at the time of deployment can be checked in along with the deployment artifacts
// produced by running the scripts.
const contractName = "AgreementEligibility";
const HATS_ID = 1;
const HATS = "0x32Ccb7600c10B4F7e678C7cbde199d98453D0e7e";
const SALT_NONCE = 1;
const FACTORY_ADDRESS = "0xd8DCBdacCA46D87502f108283C46D1748954ef51"
// What does this need to be?
const INIT_DATA = "0x000000010000000000000000000000000000000000000000000000000000000000000001000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000001b74686973206973207468652066697273742061677265656d656e740000000000"

async function main() {
  dotEnvConfig();

  const deployerPrivateKey = process.env.PRIVATE_KEY;
  if (!deployerPrivateKey) {
    throw "Please set PRIVATE_KEY in your .env file";
  }

  console.log("Deploying " + contractName + "...");

  const zkWallet = new Wallet(deployerPrivateKey);
  const deployer = new Deployer(hre, zkWallet);
  const agreementEligibility = await new Contract(FACTORY_ADDRESS, AgreementEligibilityFactory.abi, deployer.zkWallet);

  const tx = await agreementEligibility.deployAgreementEligibility(HATS_ID, HATS, INIT_DATA, SALT_NONCE);
  const tr = await tx.wait();
	console.log(tr)
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
