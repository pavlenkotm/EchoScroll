#!/usr/bin/env python3
"""
Web3.py Contract Deployment Script
Demonstrates how to deploy smart contracts using Web3.py
"""

from web3 import Web3
from solcx import compile_source, install_solc
import json
import os
from typing import Dict, Any

class ContractDeployer:
    """Deploy Ethereum smart contracts using Web3.py"""

    def __init__(self, rpc_url: str, private_key: str):
        """
        Initialize the deployer

        Args:
            rpc_url: Ethereum RPC endpoint
            private_key: Deployer's private key
        """
        self.w3 = Web3(Web3.HTTPProvider(rpc_url))

        if not self.w3.is_connected():
            raise ConnectionError(f"Failed to connect to {rpc_url}")

        self.account = self.w3.eth.account.from_key(private_key)
        print(f"✓ Connected to network")
        print(f"✓ Deployer address: {self.account.address}")
        print(f"✓ Balance: {self.w3.from_wei(self.w3.eth.get_balance(self.account.address), 'ether')} ETH")

    def compile_contract(self, contract_source: str) -> Dict[str, Any]:
        """
        Compile Solidity contract

        Args:
            contract_source: Solidity source code

        Returns:
            Compiled contract data (bytecode and ABI)
        """
        print("Compiling contract...")

        # Install Solidity compiler if needed
        install_solc('0.8.20')

        compiled_sol = compile_source(
            contract_source,
            output_values=['abi', 'bin']
        )

        # Get the contract interface
        contract_id, contract_interface = compiled_sol.popitem()

        print(f"✓ Contract compiled: {contract_id}")
        return contract_interface

    def deploy_contract(
        self,
        contract_interface: Dict[str, Any],
        *constructor_args,
        gas_limit: int = 3000000
    ) -> str:
        """
        Deploy contract to blockchain

        Args:
            contract_interface: Compiled contract data
            constructor_args: Constructor arguments
            gas_limit: Gas limit for deployment

        Returns:
            Deployed contract address
        """
        print("Deploying contract...")

        # Create contract object
        Contract = self.w3.eth.contract(
            abi=contract_interface['abi'],
            bytecode=contract_interface['bin']
        )

        # Build transaction
        nonce = self.w3.eth.get_transaction_count(self.account.address)

        transaction = Contract.constructor(*constructor_args).build_transaction({
            'chainId': self.w3.eth.chain_id,
            'gas': gas_limit,
            'gasPrice': self.w3.eth.gas_price,
            'nonce': nonce,
        })

        # Sign and send transaction
        signed_txn = self.w3.eth.account.sign_transaction(
            transaction,
            private_key=self.account.key
        )

        tx_hash = self.w3.eth.send_raw_transaction(signed_txn.rawTransaction)
        print(f"✓ Transaction sent: {tx_hash.hex()}")

        # Wait for receipt
        print("Waiting for confirmation...")
        tx_receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)

        contract_address = tx_receipt.contractAddress
        print(f"✓ Contract deployed at: {contract_address}")
        print(f"✓ Gas used: {tx_receipt.gasUsed}")

        return contract_address

    def verify_deployment(self, address: str, abi: list) -> bool:
        """
        Verify contract deployment

        Args:
            address: Contract address
            abi: Contract ABI

        Returns:
            True if deployed successfully
        """
        code = self.w3.eth.get_code(address)

        if code == b'' or code == b'0x':
            print("✗ No code at address")
            return False

        print(f"✓ Code deployed at {address}")
        print(f"  Code size: {len(code)} bytes")
        return True


def main():
    """Example usage"""

    # Example ERC20 Token contract
    contract_source = """
    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.20;

    contract SimpleToken {
        string public name;
        string public symbol;
        uint8 public decimals = 18;
        uint256 public totalSupply;

        mapping(address => uint256) public balanceOf;

        event Transfer(address indexed from, address indexed to, uint256 value);

        constructor(string memory _name, string memory _symbol, uint256 _totalSupply) {
            name = _name;
            symbol = _symbol;
            totalSupply = _totalSupply * 10 ** uint256(decimals);
            balanceOf[msg.sender] = totalSupply;
        }

        function transfer(address _to, uint256 _value) public returns (bool success) {
            require(balanceOf[msg.sender] >= _value, "Insufficient balance");
            balanceOf[msg.sender] -= _value;
            balanceOf[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
    }
    """

    # Configuration (use environment variables in production!)
    RPC_URL = os.getenv('RPC_URL', 'http://localhost:8545')
    PRIVATE_KEY = os.getenv('PRIVATE_KEY', '0x' + '0' * 64)  # Replace with real key

    try:
        # Initialize deployer
        deployer = ContractDeployer(RPC_URL, PRIVATE_KEY)

        # Compile contract
        contract_interface = deployer.compile_contract(contract_source)

        # Deploy contract
        contract_address = deployer.deploy_contract(
            contract_interface,
            "MyToken",  # name
            "MTK",      # symbol
            1000000     # total supply
        )

        # Verify deployment
        deployer.verify_deployment(contract_address, contract_interface['abi'])

        # Save deployment info
        deployment_info = {
            'address': contract_address,
            'abi': contract_interface['abi'],
            'deployer': deployer.account.address,
        }

        with open('deployment.json', 'w') as f:
            json.dump(deployment_info, f, indent=2)

        print(f"\n✓ Deployment info saved to deployment.json")

    except Exception as e:
        print(f"\n✗ Error: {e}")
        raise


if __name__ == '__main__':
    main()
