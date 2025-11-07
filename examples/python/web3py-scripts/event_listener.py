#!/usr/bin/env python3
"""
Web3.py Event Listener
Demonstrates real-time blockchain event monitoring
"""

from web3 import Web3
from web3.contract import Contract
import json
import time
import asyncio
from typing import Dict, Any, Callable


class EventListener:
    """Listen to smart contract events in real-time"""

    def __init__(self, rpc_url: str, contract_address: str, abi: list):
        """
        Initialize event listener

        Args:
            rpc_url: Ethereum RPC endpoint
            contract_address: Contract to monitor
            abi: Contract ABI
        """
        self.w3 = Web3(Web3.HTTPProvider(rpc_url))

        if not self.w3.is_connected():
            raise ConnectionError(f"Failed to connect to {rpc_url}")

        self.contract: Contract = self.w3.eth.contract(
            address=Web3.to_checksum_address(contract_address),
            abi=abi
        )

        print(f"✓ Connected to network")
        print(f"✓ Monitoring contract: {contract_address}")
        print(f"✓ Chain ID: {self.w3.eth.chain_id}")

    def get_past_events(
        self,
        event_name: str,
        from_block: int = 0,
        to_block: str = 'latest'
    ) -> list:
        """
        Get historical events

        Args:
            event_name: Name of the event
            from_block: Starting block number
            to_block: Ending block (or 'latest')

        Returns:
            List of event logs
        """
        event = getattr(self.contract.events, event_name)

        print(f"Fetching {event_name} events from block {from_block} to {to_block}...")

        events = event.get_logs(
            fromBlock=from_block,
            toBlock=to_block
        )

        print(f"✓ Found {len(events)} events")
        return events

    def watch_event(
        self,
        event_name: str,
        callback: Callable[[Dict[str, Any]], None],
        poll_interval: int = 2
    ):
        """
        Watch for new events (polling method)

        Args:
            event_name: Name of the event to watch
            callback: Function to call when event is detected
            poll_interval: Seconds between polls
        """
        event = getattr(self.contract.events, event_name)

        # Create event filter
        event_filter = event.create_filter(fromBlock='latest')

        print(f"👀 Watching for {event_name} events...")
        print(f"   Poll interval: {poll_interval}s")
        print("   Press Ctrl+C to stop\n")

        try:
            while True:
                for event_log in event_filter.get_new_entries():
                    callback(event_log)

                time.sleep(poll_interval)

        except KeyboardInterrupt:
            print("\n✓ Stopped watching events")

    async def watch_event_async(
        self,
        event_name: str,
        callback: Callable[[Dict[str, Any]], None],
        poll_interval: int = 2
    ):
        """
        Async version of event watching

        Args:
            event_name: Event to watch
            callback: Callback function
            poll_interval: Seconds between polls
        """
        event = getattr(self.contract.events, event_name)
        event_filter = event.create_filter(fromBlock='latest')

        print(f"👀 Watching for {event_name} events (async)...")

        while True:
            for event_log in event_filter.get_new_entries():
                callback(event_log)

            await asyncio.sleep(poll_interval)

    def decode_event(self, event_log: Dict[str, Any]) -> Dict[str, Any]:
        """
        Decode event log

        Args:
            event_log: Raw event log

        Returns:
            Decoded event data
        """
        return {
            'event': event_log['event'],
            'args': dict(event_log['args']),
            'block_number': event_log['blockNumber'],
            'transaction_hash': event_log['transactionHash'].hex(),
            'log_index': event_log['logIndex'],
        }


def transfer_callback(event_log: Dict[str, Any]):
    """Example callback for Transfer events"""
    data = {
        'event': event_log['event'],
        'from': event_log['args']['from'],
        'to': event_log['args']['to'],
        'value': event_log['args']['value'],
        'block': event_log['blockNumber'],
        'tx_hash': event_log['transactionHash'].hex()
    }

    print(f"📤 Transfer Event:")
    print(f"   From: {data['from']}")
    print(f"   To: {data['to']}")
    print(f"   Value: {data['value']}")
    print(f"   Block: {data['block']}")
    print(f"   Tx: {data['tx_hash'][:16]}...")
    print()


def main():
    """Example usage"""

    # Example ERC20 ABI (minimal)
    ERC20_ABI = json.loads('''[
        {
            "anonymous": false,
            "inputs": [
                {"indexed": true, "name": "from", "type": "address"},
                {"indexed": true, "name": "to", "type": "address"},
                {"indexed": false, "name": "value", "type": "uint256"}
            ],
            "name": "Transfer",
            "type": "event"
        }
    ]''')

    # Configuration
    RPC_URL = "https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY"
    CONTRACT_ADDRESS = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"  # USDC

    try:
        listener = EventListener(RPC_URL, CONTRACT_ADDRESS, ERC20_ABI)

        # Get past events
        past_events = listener.get_past_events('Transfer', from_block=-100)

        print(f"\nRecent Transfers:")
        for event in past_events[:5]:  # Show last 5
            decoded = listener.decode_event(event)
            print(f"  Block {decoded['block_number']}: {decoded['args']['value']}")

        # Watch for new events
        print("\n" + "="*60)
        listener.watch_event('Transfer', transfer_callback, poll_interval=12)

    except KeyboardInterrupt:
        print("\n✓ Stopped")
    except Exception as e:
        print(f"✗ Error: {e}")
        raise


if __name__ == '__main__':
    main()
