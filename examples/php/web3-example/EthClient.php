<?php
/**
 * PHP Ethereum Client
 * Web3 backend for PHP applications
 */

class EthClient {
    private $rpcUrl;

    public function __construct($rpcUrl = 'https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY') {
        $this->rpcUrl = $rpcUrl;
    }

    private function rpcCall($method, $params = []) {
        $data = json_encode([
            'jsonrpc' => '2.0',
            'method' => $method,
            'params' => $params,
            'id' => 1
        ]);

        $options = [
            'http' => [
                'header'  => "Content-Type: application/json\r\n",
                'method'  => 'POST',
                'content' => $data
            ]
        ];

        $context = stream_context_create($options);
        $result = file_get_contents($this->rpcUrl, false, $context);

        $response = json_decode($result, true);
        return $response['result'] ?? null;
    }

    public function getBlockNumber() {
        $hex = $this->rpcCall('eth_blockNumber');
        return hexdec($hex);
    }

    public function getBalance($address) {
        return $this->rpcCall('eth_getBalance', [$address, 'latest']);
    }

    public function getGasPrice() {
        return $this->rpcCall('eth_gasPrice');
    }

    public function getTransaction($txHash) {
        return $this->rpcCall('eth_getTransactionByHash', [$txHash]);
    }

    public function weiToEther($wei) {
        return bcdiv($wei, '1000000000000000000', 18);
    }
}

// Example usage
$client = new EthClient();
$vitalik = '0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045';

echo "Block Number: " . $client->getBlockNumber() . PHP_EOL;
$balance = $client->getBalance($vitalik);
echo "Balance: " . $client->weiToEther($balance) . " ETH" . PHP_EOL;
echo "Gas Price: " . $client->getGasPrice() . PHP_EOL;
?>
