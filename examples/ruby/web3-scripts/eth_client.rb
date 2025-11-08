#!/usr/bin/env ruby
# frozen_string_literal: true

# Ruby Ethereum Client
# Web3 interactions using eth.rb gem

require 'eth'
require 'net/http'
require 'json'

class EthereumClient
  def initialize(rpc_url = 'https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY')
    @rpc_url = URI(rpc_url)
    @client = Eth::Client.create(rpc_url)
  end

  # Get ETH balance
  def get_balance(address)
    balance_wei = @client.eth_get_balance(address)['result'].to_i(16)
    wei_to_ether(balance_wei)
  end

  # Get current block number
  def get_block_number
    @client.eth_block_number['result'].to_i(16)
  end

  # Get transaction by hash
  def get_transaction(tx_hash)
    @client.eth_get_transaction_by_hash(tx_hash)['result']
  end

  # Send raw transaction
  def send_transaction(from_key, to_address, amount_ether)
    key = Eth::Key.new(priv: from_key)
    from_address = key.address.to_s

    # Get nonce
    nonce = @client.eth_get_transaction_count(from_address)['result'].to_i(16)

    # Build transaction
    tx = Eth::Tx.new({
      nonce: nonce,
      gas_price: get_gas_price,
      gas_limit: 21_000,
      to: to_address,
      value: ether_to_wei(amount_ether)
    })

    # Sign transaction
    tx.sign(key)

    # Send transaction
    @client.eth_send_raw_transaction(tx.hex)['result']
  end

  # Get current gas price
  def get_gas_price
    @client.eth_gas_price['result'].to_i(16)
  end

  # Get transaction receipt
  def get_receipt(tx_hash)
    @client.eth_get_transaction_receipt(tx_hash)['result']
  end

  # Call contract method (read-only)
  def call_contract(contract_address, data)
    @client.eth_call({
      to: contract_address,
      data: data
    })['result']
  end

  # Get ERC-20 token balance
  def get_token_balance(token_address, wallet_address)
    # balanceOf(address) function selector: 0x70a08231
    data = '0x70a08231' + wallet_address[2..-1].rjust(64, '0')
    result = call_contract(token_address, data)
    result.to_i(16)
  end

  # Sign message
  def sign_message(message, private_key)
    key = Eth::Key.new(priv: private_key)
    signature = key.sign(message)
    signature.unpack1('H*')
  end

  # Verify signature
  def verify_signature(message, signature, address)
    public_key = Eth::Signature.recover(message, signature)
    Eth::Address.new(public_key).to_s == address.downcase
  end

  private

  def wei_to_ether(wei)
    wei.to_f / 1_000_000_000_000_000_000
  end

  def ether_to_wei(ether)
    (ether * 1_000_000_000_000_000_000).to_i
  end

  # Make JSON-RPC call
  def rpc_call(method, params = [])
    request = Net::HTTP::Post.new(@rpc_url)
    request.content_type = 'application/json'
    request.body = {
      jsonrpc: '2.0',
      method: method,
      params: params,
      id: 1
    }.to_json

    response = Net::HTTP.start(@rpc_url.hostname, @rpc_url.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end
end

# Example usage
if __FILE__ == $PROGRAM_NAME
  client = EthereumClient.new

  # Get Vitalik's balance
  vitalik = '0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045'
  balance = client.get_balance(vitalik)
  puts "Vitalik's Balance: #{balance} ETH"

  # Get current block
  block_number = client.get_block_number
  puts "Current Block: #{block_number}"

  # Get gas price
  gas_price = client.get_gas_price
  puts "Gas Price: #{gas_price} Wei"
end
