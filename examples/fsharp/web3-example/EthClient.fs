// F# Ethereum Client
// Functional Web3 on .NET

module EthClient

open System
open System.Net.Http
open System.Text
open System.Text.Json

type RpcRequest = {
    jsonrpc: string
    method: string
    ``params``: obj[]
    id: int
}

type RpcResponse = {
    result: JsonElement
}

let httpClient = new HttpClient()

let rpcCall (rpcUrl: string) (method: string) (parameters: obj[]) =
    async {
        let request = {
            jsonrpc = "2.0"
            method = method
            ``params`` = parameters
            id = 1
        }

        let json = JsonSerializer.Serialize(request)
        let content = new StringContent(json, Encoding.UTF8, "application/json")

        let! response = httpClient.PostAsync(rpcUrl, content) |> Async.AwaitTask
        let! body = response.Content.ReadAsStringAsync() |> Async.AwaitTask

        let result = JsonSerializer.Deserialize<RpcResponse>(body)
        return result.result
    }

let getBlockNumber rpcUrl =
    async {
        let! result = rpcCall rpcUrl "eth_blockNumber" [||]
        let hex = result.GetString()
        return Convert.ToInt64(hex, 16)
    }

let getBalance rpcUrl address =
    async {
        let! result = rpcCall rpcUrl "eth_getBalance" [| address; "latest" |]
        return result.GetString()
    }

let getGasPrice rpcUrl =
    async {
        let! result = rpcCall rpcUrl "eth_gasPrice" [||]
        return result.GetString()
    }

[<EntryPoint>]
let main argv =
    let rpcUrl = "https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY"
    let vitalik = "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"

    async {
        let! blockNumber = getBlockNumber rpcUrl
        let! balance = getBalance rpcUrl vitalik
        let! gasPrice = getGasPrice rpcUrl

        printfn "Block Number: %d" blockNumber
        printfn "Balance: %s" balance
        printfn "Gas Price: %s" gasPrice
    }
    |> Async.RunSynchronously

    0
