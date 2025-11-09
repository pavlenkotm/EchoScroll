/**
 * Tests for JavaScript Web3 Integration
 * Test the wallet functionality
 */

const { Web3 } = require('web3');

describe('Web3Wallet Tests', () => {
    test('should create Web3 instance', () => {
        const web3 = new Web3('https://eth-mainnet.g.alchemy.com/v2/demo');
        expect(web3).toBeDefined();
        expect(web3.eth).toBeDefined();
        expect(web3.utils).toBeDefined();
    });

    test('should convert wei to ether', () => {
        const web3 = new Web3();
        const weiValue = '1000000000000000000'; // 1 ETH in wei
        const etherValue = web3.utils.fromWei(weiValue, 'ether');
        expect(etherValue).toBe('1');
    });

    test('should convert ether to wei', () => {
        const web3 = new Web3();
        const etherValue = '1';
        const weiValue = web3.utils.toWei(etherValue, 'ether');
        expect(weiValue).toBe('1000000000000000000');
    });

    test('should validate Ethereum address format', () => {
        const web3 = new Web3();
        const validAddress = '0x742d35Cc6634C0532925a3b844Bc454e4438f44e';
        const invalidAddress = '0x123';

        expect(web3.utils.isAddress(validAddress)).toBe(true);
        expect(web3.utils.isAddress(invalidAddress)).toBe(false);
    });

    test('should create account from private key', () => {
        const web3 = new Web3();
        const privateKey = '0x' + '1'.repeat(64); // Test private key
        const account = web3.eth.accounts.privateKeyToAccount(privateKey);

        expect(account).toBeDefined();
        expect(account.address).toBeDefined();
        expect(account.privateKey).toBe(privateKey);
    });

    test('should hash data using keccak256', () => {
        const web3 = new Web3();
        const data = 'Hello, Web3!';
        const hash = web3.utils.keccak256(data);

        expect(hash).toBeDefined();
        expect(hash).toMatch(/^0x[a-fA-F0-9]{64}$/);
    });
});
