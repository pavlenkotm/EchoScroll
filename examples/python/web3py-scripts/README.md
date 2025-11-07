# Python Web3.py Scripts

## Overview

This directory contains Python scripts demonstrating Web3.py usage for Ethereum blockchain interaction. Web3.py is the most popular Python library for interacting with Ethereum.

## Scripts

- **contract_deployer.py** - Deploy smart contracts programmatically
- **event_listener.py** - Monitor blockchain events in real-time
- **requirements.txt** - Python dependencies

## Features

### Contract Deployer
- ✅ Compile Solidity contracts from source
- ✅ Deploy contracts with constructor arguments
- ✅ Gas estimation and management
- ✅ Deployment verification
- ✅ Save deployment artifacts

### Event Listener
- ✅ Fetch historical events
- ✅ Real-time event monitoring (polling)
- ✅ Async event watching
- ✅ Event decoding and formatting
- ✅ Custom callbacks for event handling

## Setup

### Prerequisites

- Python 3.8+
- pip

### Install Dependencies

```bash
pip install -r requirements.txt
```

### Environment Variables

Create a `.env` file:

```bash
RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY
PRIVATE_KEY=your_private_key_here
```

Or export directly:

```bash
export RPC_URL="https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY"
export PRIVATE_KEY="your_private_key_here"
```

## Usage

### Deploy a Contract

```bash
python contract_deployer.py
```

The script will:
1. Connect to the network
2. Compile the Solidity contract
3. Deploy to the blockchain
4. Save deployment info to `deployment.json`

### Listen to Events

```bash
python event_listener.py
```

Monitor USDC transfers in real-time:

```python
from event_listener import EventListener

listener = EventListener(RPC_URL, USDC_ADDRESS, ERC20_ABI)

# Get past events
events = listener.get_past_events('Transfer', from_block=-1000)

# Watch for new events
listener.watch_event('Transfer', transfer_callback)
```

## Examples

### Connect to Ethereum

```python
from web3 import Web3

w3 = Web3(Web3.HTTPProvider('https://eth-mainnet.g.alchemy.com/v2/API_KEY'))

if w3.is_connected():
    print(f"Connected! Latest block: {w3.eth.block_number}")
    print(f"Gas price: {w3.from_wei(w3.eth.gas_price, 'gwei')} gwei")
```

### Get Account Balance

```python
address = "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb"
balance_wei = w3.eth.get_balance(address)
balance_eth = w3.from_wei(balance_wei, 'ether')
print(f"Balance: {balance_eth} ETH")
```

### Send Transaction

```python
from eth_account import Account

account = Account.from_key(private_key)

transaction = {
    'to': '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb',
    'value': w3.to_wei(0.01, 'ether'),
    'gas': 21000,
    'gasPrice': w3.eth.gas_price,
    'nonce': w3.eth.get_transaction_count(account.address),
    'chainId': 1
}

signed = account.sign_transaction(transaction)
tx_hash = w3.eth.send_raw_transaction(signed.rawTransaction)
receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
```

### Interact with Contract

```python
# Load contract
contract = w3.eth.contract(address=contract_address, abi=abi)

# Call view function
balance = contract.functions.balanceOf(address).call()

# Send transaction
tx = contract.functions.transfer(to_address, amount).build_transaction({
    'from': account.address,
    'gas': 100000,
    'gasPrice': w3.eth.gas_price,
    'nonce': w3.eth.get_transaction_count(account.address),
})

signed_tx = account.sign_transaction(tx)
tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
```

### Estimate Gas

```python
gas_estimate = contract.functions.transfer(
    to_address,
    amount
).estimate_gas({'from': account.address})

print(f"Estimated gas: {gas_estimate}")
```

### Get Transaction Info

```python
tx = w3.eth.get_transaction(tx_hash)
print(f"From: {tx['from']}")
print(f"To: {tx['to']}")
print(f"Value: {w3.from_wei(tx['value'], 'ether')} ETH")
print(f"Gas Price: {w3.from_wei(tx['gasPrice'], 'gwei')} gwei")

receipt = w3.eth.get_transaction_receipt(tx_hash)
print(f"Status: {'Success' if receipt['status'] == 1 else 'Failed'}")
print(f"Gas Used: {receipt['gasUsed']}")
```

## Advanced Usage

### Work with ENS Names

```python
from web3 import Web3
from ens import ENS

w3 = Web3(Web3.HTTPProvider('https://eth-mainnet.g.alchemy.com/v2/API_KEY'))
ns = ENS.from_web3(w3)

# Resolve ENS name to address
address = ns.address('vitalik.eth')

# Get ENS name from address
name = ns.name(address)
```

### Sign Messages

```python
from eth_account.messages import encode_defunct

message = "Sign this message"
message_encoded = encode_defunct(text=message)
signed_message = account.sign_message(message_encoded)

print(f"Signature: {signed_message.signature.hex()}")

# Verify signature
recovered_address = w3.eth.account.recover_message(
    message_encoded,
    signature=signed_message.signature
)
assert recovered_address == account.address
```

### Batch Requests

```python
from web3 import Web3
from web3.middleware import batch_request_middleware

w3 = Web3(Web3.HTTPProvider('https://eth-mainnet.g.alchemy.com/v2/API_KEY'))
w3.middleware_onion.inject(batch_request_middleware, layer=0)

# Make multiple requests in one call
with w3.batch_requests() as batch:
    batch.add(w3.eth.get_balance, '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb')
    batch.add(w3.eth.block_number)
    batch.add(w3.eth.gas_price)
    responses = batch.execute()
```

## Testing

Run tests:

```bash
pytest test_web3_scripts.py
```

## Common Patterns

### Retry on Failure

```python
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(stop=stop_after_attempt(3), wait=wait_exponential(multiplier=1, min=2, max=10))
def send_transaction_with_retry(tx):
    return w3.eth.send_raw_transaction(tx)
```

### Handle Reorgs

```python
def wait_for_transaction_receipt_with_confirmations(tx_hash, confirmations=6):
    receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

    while w3.eth.block_number - receipt['blockNumber'] < confirmations:
        time.sleep(12)  # Average block time

    return receipt
```

## Resources

- [Web3.py Documentation](https://web3py.readthedocs.io/)
- [Ethereum Python Docs](https://ethereum.org/en/developers/docs/programming-languages/python/)
- [Web3.py GitHub](https://github.com/ethereum/web3.py)
- [Brownie Framework](https://eth-brownie.readthedocs.io/)

## Best Practices

- Never commit private keys
- Use environment variables for sensitive data
- Implement retry logic for network calls
- Estimate gas before sending transactions
- Wait for sufficient confirmations
- Handle exceptions properly
- Use checksummed addresses
- Validate all inputs

## Security

⚠️ **Important Security Notes:**
- Never hardcode private keys
- Use `.env` files (add to `.gitignore`)
- Consider using hardware wallets
- Verify contract addresses
- Test on testnet first

## License

MIT
