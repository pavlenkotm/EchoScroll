(ns eth-client.core
  "Clojure Ethereum Client - Lisp for Web3"
  (:require [clj-http.client :as client]
            [cheshire.core :as json]))

(defn rpc-call
  [rpc-url method params]
  (let [body (json/generate-string
              {:jsonrpc "2.0"
               :method method
               :params params
               :id 1})
        response (client/post rpc-url
                             {:body body
                              :headers {"Content-Type" "application/json"}
                              :as :json})]
    (get-in response [:body :result])))

(defn get-block-number
  [rpc-url]
  (let [hex-result (rpc-call rpc-url "eth_blockNumber" [])]
    (Long/parseLong (subs hex-result 2) 16)))

(defn get-balance
  [rpc-url address]
  (rpc-call rpc-url "eth_getBalance" [address "latest"]))

(defn get-gas-price
  [rpc-url]
  (rpc-call rpc-url "eth_gasPrice" []))

(defn -main
  [& args]
  (let [rpc-url "https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY"
        vitalik "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"]

    (println "Block Number:" (get-block-number rpc-url))
    (println "Balance:" (get-balance rpc-url vitalik))
    (println "Gas Price:" (get-gas-price rpc-url))))
