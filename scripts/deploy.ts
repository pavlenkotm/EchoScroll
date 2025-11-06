import { Wallet } from "zksync-ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Deployer } from "@matterlabs/hardhat-zksync";

export default async function (hre: HardhatRuntimeEnvironment) {
  console.log("🔮 Deploying EchoScroll to zkSync...");

  const wallet = new Wallet(process.env.PRIVATE_KEY || "");
  const deployer = new Deployer(hre, wallet);
  const artifact = await deployer.loadArtifact("EchoScroll");

  const echoScroll = await deployer.deploy(artifact);

  console.log("✨ EchoScroll deployed at:", await echoScroll.getAddress());
  console.log("🎯 Save this address to your .env file as NEXT_PUBLIC_CONTRACT_ADDRESS");
}
