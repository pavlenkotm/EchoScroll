package com.web3.example;

import org.web3j.crypto.Credentials;
import org.web3j.crypto.ECKeyPair;
import org.web3j.crypto.Keys;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.EthBlockNumber;
import org.web3j.protocol.core.methods.response.EthGasPrice;
import org.web3j.protocol.core.methods.response.EthGetBalance;
import org.web3j.protocol.http.HttpService;
import org.web3j.utils.Convert;

import java.math.BigDecimal;
import java.math.BigInteger;

/**
 * Web3j Example - Interact with Ethereum blockchain using Java
 */
public class Web3Example {

    private Web3j web3j;

    public Web3Example(String rpcUrl) {
        this.web3j = Web3j.build(new HttpService(rpcUrl));
    }

    /**
     * Get the latest block number
     */
    public BigInteger getBlockNumber() throws Exception {
        EthBlockNumber blockNumber = web3j.ethBlockNumber().send();
        return blockNumber.getBlockNumber();
    }

    /**
     * Get balance for an address in ETH
     */
    public BigDecimal getBalance(String address) throws Exception {
        EthGetBalance balance = web3j
                .ethGetBalance(address, org.web3j.protocol.core.DefaultBlockParameterName.LATEST)
                .send();

        return Convert.fromWei(balance.getBalance().toString(), Convert.Unit.ETHER);
    }

    /**
     * Get current gas price in Gwei
     */
    public BigDecimal getGasPrice() throws Exception {
        EthGasPrice gasPrice = web3j.ethGasPrice().send();
        return Convert.fromWei(gasPrice.getGasPrice().toString(), Convert.Unit.GWEI);
    }

    /**
     * Generate a new Ethereum wallet
     */
    public static Credentials generateWallet() throws Exception {
        ECKeyPair keyPair = Keys.createEcKeyPair();
        return Credentials.create(keyPair);
    }

    /**
     * Get wallet from private key
     */
    public static Credentials getWallet(String privateKey) {
        return Credentials.create(privateKey);
    }

    public void close() {
        web3j.shutdown();
    }

    public static void main(String[] args) {
        System.out.println("🌐 Web3j Ethereum Client\n");

        String rpcUrl = "https://eth.llamarpc.com";
        Web3Example client = new Web3Example(rpcUrl);

        try {
            // Get latest block
            BigInteger blockNumber = client.getBlockNumber();
            System.out.println("Latest Block: " + blockNumber);

            // Get gas price
            BigDecimal gasPrice = client.getGasPrice();
            System.out.println("Gas Price: " + gasPrice + " gwei\n");

            // Check Vitalik's balance
            String vitalikAddress = "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045";
            BigDecimal balance = client.getBalance(vitalikAddress);
            System.out.println("💰 Balance for " + vitalikAddress);
            System.out.println("   " + balance + " ETH\n");

            // Generate new wallet
            Credentials credentials = generateWallet();
            System.out.println("🔐 Generated New Wallet:");
            System.out.println("   Address: " + credentials.getAddress());
            System.out.println("   Private Key: " + credentials.getEcKeyPair().getPrivateKey().toString(16));
            System.out.println("\n   ⚠️  KEEP YOUR PRIVATE KEY SAFE!\n");

            System.out.println("✓ Done!");

        } catch (Exception e) {
            System.err.println("✗ Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            client.close();
        }
    }
}
