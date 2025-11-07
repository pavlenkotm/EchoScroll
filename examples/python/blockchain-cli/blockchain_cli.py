#!/usr/bin/env python3
"""
Blockchain CLI Tool
A command-line interface for interacting with Ethereum blockchain
"""

import click
from web3 import Web3
from eth_account import Account
import json
from typing import Optional


class BlockchainCLI:
    """CLI tool for blockchain operations"""

    def __init__(self, rpc_url: str):
        self.w3 = Web3(Web3.HTTPProvider(rpc_url))

        if not self.w3.is_connected():
            click.echo(click.style(f"✗ Failed to connect to {rpc_url}", fg='red'))
            raise SystemExit(1)

    def get_balance(self, address: str) -> float:
        """Get ETH balance for address"""
        balance_wei = self.w3.eth.get_balance(Web3.to_checksum_address(address))
        return self.w3.from_wei(balance_wei, 'ether')

    def get_block_info(self, block_number: str = 'latest') -> dict:
        """Get block information"""
        if block_number == 'latest':
            block = self.w3.eth.get_block('latest')
        else:
            block = self.w3.eth.get_block(int(block_number))

        return dict(block)

    def get_transaction(self, tx_hash: str) -> dict:
        """Get transaction details"""
        tx = self.w3.eth.get_transaction(tx_hash)
        return dict(tx)

    def get_gas_price(self) -> float:
        """Get current gas price in gwei"""
        return self.w3.from_wei(self.w3.eth.gas_price, 'gwei')


@click.group()
@click.option('--rpc', default='https://eth-mainnet.g.alchemy.com/v2/demo', help='RPC endpoint')
@click.pass_context
def cli(ctx, rpc):
    """Blockchain CLI - Interact with Ethereum from command line"""
    ctx.ensure_object(dict)
    ctx.obj['cli'] = BlockchainCLI(rpc)
    ctx.obj['rpc'] = rpc


@cli.command()
@click.argument('address')
@click.pass_context
def balance(ctx, address):
    """Get ETH balance for an address"""
    cli_obj = ctx.obj['cli']

    try:
        bal = cli_obj.get_balance(address)
        click.echo(f"\n💰 Balance for {address}")
        click.echo(f"   {bal:.6f} ETH")

    except Exception as e:
        click.echo(click.style(f"✗ Error: {e}", fg='red'))


@cli.command()
@click.argument('block_number', default='latest')
@click.pass_context
def block(ctx, block_number):
    """Get block information"""
    cli_obj = ctx.obj['cli']

    try:
        block_info = cli_obj.get_block_info(block_number)

        click.echo(f"\n📦 Block #{block_info['number']}")
        click.echo(f"   Hash: {block_info['hash'].hex()}")
        click.echo(f"   Timestamp: {block_info['timestamp']}")
        click.echo(f"   Transactions: {len(block_info['transactions'])}")
        click.echo(f"   Gas Used: {block_info['gasUsed']:,}")
        click.echo(f"   Gas Limit: {block_info['gasLimit']:,}")
        click.echo(f"   Base Fee: {block_info.get('baseFeePerGas', 0):,} wei")

    except Exception as e:
        click.echo(click.style(f"✗ Error: {e}", fg='red'))


@cli.command()
@click.argument('tx_hash')
@click.pass_context
def tx(ctx, tx_hash):
    """Get transaction details"""
    cli_obj = ctx.obj['cli']

    try:
        tx_info = cli_obj.get_transaction(tx_hash)

        click.echo(f"\n📤 Transaction {tx_hash}")
        click.echo(f"   From: {tx_info['from']}")
        click.echo(f"   To: {tx_info['to']}")
        click.echo(f"   Value: {cli_obj.w3.from_wei(tx_info['value'], 'ether')} ETH")
        click.echo(f"   Gas Price: {cli_obj.w3.from_wei(tx_info['gasPrice'], 'gwei')} gwei")
        click.echo(f"   Gas: {tx_info['gas']:,}")
        click.echo(f"   Nonce: {tx_info['nonce']}")
        click.echo(f"   Block: {tx_info['blockNumber']}")

    except Exception as e:
        click.echo(click.style(f"✗ Error: {e}", fg='red'))


@cli.command()
@click.pass_context
def gas(ctx):
    """Get current gas price"""
    cli_obj = ctx.obj['cli']

    try:
        gas_price = cli_obj.get_gas_price()
        click.echo(f"\n⛽ Current Gas Price")
        click.echo(f"   {gas_price:.2f} gwei")

    except Exception as e:
        click.echo(click.style(f"✗ Error: {e}", fg='red'))


@cli.command()
@click.pass_context
def info(ctx):
    """Get network information"""
    cli_obj = ctx.obj['cli']

    try:
        latest_block = cli_obj.w3.eth.block_number
        gas_price = cli_obj.get_gas_price()
        chain_id = cli_obj.w3.eth.chain_id

        click.echo(f"\n🌐 Network Information")
        click.echo(f"   RPC: {ctx.obj['rpc']}")
        click.echo(f"   Chain ID: {chain_id}")
        click.echo(f"   Latest Block: {latest_block:,}")
        click.echo(f"   Gas Price: {gas_price:.2f} gwei")
        click.echo(f"   Connected: {cli_obj.w3.is_connected()}")

    except Exception as e:
        click.echo(click.style(f"✗ Error: {e}", fg='red'))


@cli.command()
def generate_wallet():
    """Generate a new Ethereum wallet"""
    account = Account.create()

    click.echo(f"\n🔐 New Wallet Generated")
    click.echo(f"   Address: {account.address}")
    click.echo(f"   Private Key: {account.key.hex()}")
    click.echo(click.style("\n   ⚠️  KEEP YOUR PRIVATE KEY SAFE!", fg='yellow', bold=True))


if __name__ == '__main__':
    cli(obj={})
