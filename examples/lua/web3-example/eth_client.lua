-- Lua Ethereum Client
-- Lightweight scripting for Web3

local json = require("dkjson")
local http = require("socket.http")
local ltn12 = require("ltn12")

local EthClient = {}
EthClient.__index = EthClient

function EthClient:new(rpc_url)
    local obj = {
        rpc_url = rpc_url or "https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY"
    }
    setmetatable(obj, EthClient)
    return obj
end

function EthClient:rpc_call(method, params)
    local request_body = json.encode({
        jsonrpc = "2.0",
        method = method,
        params = params or {},
        id = 1
    })

    local response_body = {}

    local res, code = http.request{
        url = self.rpc_url,
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#request_body)
        },
        source = ltn12.source.string(request_body),
        sink = ltn12.sink.table(response_body)
    }

    if code == 200 then
        local response = json.decode(table.concat(response_body))
        return response.result
    else
        return nil, "HTTP error: " .. tostring(code)
    end
end

function EthClient:get_block_number()
    return self:rpc_call("eth_blockNumber", {})
end

function EthClient:get_balance(address)
    return self:rpc_call("eth_getBalance", {address, "latest"})
end

function EthClient:get_gas_price()
    return self:rpc_call("eth_gasPrice", {})
end

-- Example usage
local client = EthClient:new()
local vitalik = "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"

print("Block Number:", client:get_block_number())
print("Balance:", client:get_balance(vitalik))
print("Gas Price:", client:get_gas_price())

return EthClient
