/**
 * JavaScript Web3 Wallet Integration
 * Modern Web3.js example for Ethereum interaction
 */

const { Web3 } = require('web3');
const fs = require('fs');

class Web3Wallet {
    constructor(rpcUrl = 'https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY') {
        this.web3 = new Web3(rpcUrl);
    }

    /**
     * Get ETH balance for an address
     */
    async getBalance(address) {
        const balance = await this.web3.eth.getBalance(address);
        return this.web3.utils.fromWei(balance, 'ether');
    }

    /**
     * Send ETH transaction
     */
    async sendTransaction(from, to, amount, privateKey) {
        const account = this.web3.eth.accounts.privateKeyToAccount(privateKey);
        this.web3.eth.accounts.wallet.add(account);

        const tx = {
            from: from,
            to: to,
            value: this.web3.utils.toWei(amount, 'ether'),
            gas: 21000,
        };

        const receipt = await this.web3.eth.sendTransaction(tx);
        return receipt;
    }

    /**
     * Interact with ERC-20 token
     */
    async getTokenBalance(tokenAddress, walletAddress) {
        const minABI = [
            {
                constant: true,
                inputs: [{ name: '_owner', type: 'address' }],
                name: 'balanceOf',
                outputs: [{ name: 'balance', type: 'uint256' }],
                type: 'function',
            },
            {
                constant: true,
                inputs: [],
                name: 'decimals',
                outputs: [{ name: '', type: 'uint8' }],
                type: 'function',
            },
        ];

        const contract = new this.web3.eth.Contract(minABI, tokenAddress);
        const balance = await contract.methods.balanceOf(walletAddress).call();
        const decimals = await contract.methods.decimals().call();

        return Number(balance) / 10 ** Number(decimals);
    }

    /**
     * Transfer ERC-20 tokens
     */
    async transferToken(tokenAddress, from, to, amount, privateKey) {
        const account = this.web3.eth.accounts.privateKeyToAccount(privateKey);
        this.web3.eth.accounts.wallet.add(account);

        const minABI = [
            {
                constant: false,
                inputs: [
                    { name: '_to', type: 'address' },
                    { name: '_value', type: 'uint256' },
                ],
                name: 'transfer',
                outputs: [{ name: '', type: 'bool' }],
                type: 'function',
            },
        ];

        const contract = new this.web3.eth.Contract(minABI, tokenAddress);
        const tx = contract.methods.transfer(to, amount);

        const gas = await tx.estimateGas({ from: from });
        const receipt = await tx.send({ from: from, gas: gas });

        return receipt;
    }

    /**
     * Sign a message
     */
    async signMessage(message, privateKey) {
        const account = this.web3.eth.accounts.privateKeyToAccount(privateKey);
        const signature = account.sign(message);
        return signature;
    }

    /**
     * Verify signature
     */
    recoverSigner(message, signature) {
        return this.web3.eth.accounts.recover(message, signature);
    }

    /**
     * Get current gas price
     */
    async getGasPrice() {
        const gasPrice = await this.web3.eth.getGasPrice();
        return this.web3.utils.fromWei(gasPrice, 'gwei');
    }

    /**
     * Get latest block number
     */
    async getBlockNumber() {
        return await this.web3.eth.getBlockNumber();
    }

    /**
     * Listen for new blocks
     */
    subscribeToBlocks(callback) {
        const subscription = this.web3.eth.subscribe('newBlockHeaders');
        subscription.on('data', callback);
        return subscription;
    }
}

// Example usage
async function main() {
    const wallet = new Web3Wallet();

    // Get balance
    const balance = await wallet.getBalance('0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb');
    console.log(`Balance: ${balance} ETH`);

    // Get gas price
    const gasPrice = await wallet.getGasPrice();
    console.log(`Gas Price: ${gasPrice} Gwei`);

    // Get block number
    const blockNumber = await wallet.getBlockNumber();
    console.log(`Latest Block: ${blockNumber}`);
}

if (require.main === module) {
    main().catch(console.error);
}

module.exports = Web3Wallet;
