# Crystal Ethereum Client
# Ruby-like syntax with C-like performance

require "http/client"
require "json"

class EthClient
  def initialize(@rpc_url : String)
    @client = HTTP::Client.new(URI.parse(@rpc_url))
  end

  def rpc_call(method : String, params : Array)
    body = {
      jsonrpc: "2.0",
      method: method,
      params: params,
      id: 1
    }.to_json

    response = @client.post("/",
      headers: HTTP::Headers{"Content-Type" => "application/json"},
      body: body
    )

    JSON.parse(response.body)["result"]
  end

  def get_block_number : Int64
    result = rpc_call("eth_blockNumber", [] of String)
    result.as_s.lchop("0x").to_i64(16)
  end

  def get_balance(address : String) : String
    result = rpc_call("eth_getBalance", [address, "latest"])
    result.as_s
  end

  def get_gas_price : String
    result = rpc_call("eth_gasPrice", [] of String)
    result.as_s
  end
end

# Example usage
if PROGRAM_NAME == __FILE__
  client = EthClient.new("https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY")

  vitalik = "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"

  puts "Block Number: #{client.get_block_number}"
  puts "Balance: #{client.get_balance(vitalik)}"
  puts "Gas Price: #{client.get_gas_price}"
end
