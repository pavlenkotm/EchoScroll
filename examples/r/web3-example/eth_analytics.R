# R Ethereum Analytics
# Statistical analysis for blockchain data

library(httr)
library(jsonlite)

EthClient <- R6::R6Class("EthClient",
  public = list(
    rpc_url = NULL,

    initialize = function(rpc_url = "https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY") {
      self$rpc_url <- rpc_url
    },

    rpc_call = function(method, params = list()) {
      body <- list(
        jsonrpc = "2.0",
        method = method,
        params = params,
        id = 1
      )

      response <- POST(
        self$rpc_url,
        body = toJSON(body, auto_unbox = TRUE),
        add_headers("Content-Type" = "application/json")
      )

      content <- content(response, as = "parsed")
      return(content$result)
    },

    get_block_number = function() {
      hex <- self$rpc_call("eth_blockNumber")
      return(strtoi(hex, base = 16L))
    },

    get_balance = function(address) {
      return(self$rpc_call("eth_getBalance", list(address, "latest")))
    },

    get_gas_price = function() {
      return(self$rpc_call("eth_gasPrice"))
    },

    wei_to_ether = function(wei_hex) {
      wei <- as.numeric(strtoi(wei_hex, base = 16L))
      ether <- wei / 1e18
      return(ether)
    }
  )
)

# Example usage
client <- EthClient$new()
vitalik <- "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"

block_number <- client$get_block_number()
balance <- client$get_balance(vitalik)
balance_eth <- client$wei_to_ether(balance)

cat("Block Number:", block_number, "\n")
cat("Balance:", balance_eth, "ETH\n")

# Statistical analysis example
blocks <- sapply(1:10, function(x) client$get_block_number())
cat("Block mean:", mean(blocks), "\n")
cat("Block variance:", var(blocks), "\n")
