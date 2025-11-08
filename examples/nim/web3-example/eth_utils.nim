# Nim Ethereum Utilities
# Systems programming for Web3

import std/[httpclient, json, strutils, sequtils]
import std/sha1  # For hashing examples

type
  EthClient* = object
    rpcUrl: string
    client: HttpClient

proc newEthClient*(rpcUrl: string): EthClient =
  EthClient(
    rpcUrl: rpcUrl,
    client: newHttpClient()
  )

proc rpcCall*(client: var EthClient, `method`: string, params: JsonNode): JsonNode =
  let body = %*{
    "jsonrpc": "2.0",
    "method": `method`,
    "params": params,
    "id": 1
  }

  client.client.headers = newHttpHeaders({"Content-Type": "application/json"})
  let response = client.client.request(client.rpcUrl, httpMethod = HttpPost, body = $body)
  parseJson(response.body)["result"]

proc getBlockNumber*(client: var EthClient): int =
  let result = client.rpcCall("eth_blockNumber", newJArray())
  parseHexInt(result.getStr)

proc getBalance*(client: var EthClient, address: string): string =
  let result = client.rpcCall("eth_getBalance", %*[address, "latest"])
  result.getStr

proc getGasPrice*(client: var EthClient): string =
  let result = client.rpcCall("eth_gasPrice", newJArray())
  result.getStr

when isMainModule:
  var client = newEthClient("https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY")

  let vitalik = "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"

  echo "Block Number: ", client.getBlockNumber()
  echo "Balance: ", client.getBalance(vitalik)
  echo "Gas Price: ", client.getGasPrice()
