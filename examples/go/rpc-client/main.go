package main

import (
	"context"
	"fmt"
	"log"
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/ethclient"
)

// RPCClient wraps Ethereum RPC client functionality
type RPCClient struct {
	client *ethclient.Client
	ctx    context.Context
}

// NewRPCClient creates a new RPC client
func NewRPCClient(rpcURL string) (*RPCClient, error) {
	client, err := ethclient.Dial(rpcURL)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to %s: %v", rpcURL, err)
	}

	return &RPCClient{
		client: client,
		ctx:    context.Background(),
	}, nil
}

// GetChainID returns the chain ID
func (r *RPCClient) GetChainID() (*big.Int, error) {
	return r.client.ChainID(r.ctx)
}

// GetBalance returns the balance of an address in wei
func (r *RPCClient) GetBalance(address string) (*big.Int, error) {
	addr := common.HexToAddress(address)
	return r.client.BalanceAt(r.ctx, addr, nil)
}

// GetBlockNumber returns the latest block number
func (r *RPCClient) GetBlockNumber() (uint64, error) {
	return r.client.BlockNumber(r.ctx)
}

// GetBlock returns block information by number
func (r *RPCClient) GetBlock(blockNumber *big.Int) (*types.Block, error) {
	return r.client.BlockByNumber(r.ctx, blockNumber)
}

// GetTransaction returns transaction details
func (r *RPCClient) GetTransaction(txHash string) (*types.Transaction, bool, error) {
	hash := common.HexToHash(txHash)
	return r.client.TransactionByHash(r.ctx, hash)
}

// GetTransactionReceipt returns transaction receipt
func (r *RPCClient) GetTransactionReceipt(txHash string) (*types.Receipt, error) {
	hash := common.HexToHash(txHash)
	return r.client.TransactionReceipt(r.ctx, hash)
}

// GetGasPrice returns current gas price in wei
func (r *RPCClient) GetGasPrice() (*big.Int, error) {
	return r.client.SuggestGasPrice(r.ctx)
}

// GetNonce returns the account nonce
func (r *RPCClient) GetNonce(address string) (uint64, error) {
	addr := common.HexToAddress(address)
	return r.client.PendingNonceAt(r.ctx, addr)
}

// EstimateGas estimates gas for a transaction
func (r *RPCClient) EstimateGas(from, to string, value *big.Int, data []byte) (uint64, error) {
	fromAddr := common.HexToAddress(from)
	toAddr := common.HexToAddress(to)

	msg := types.CallMsg{
		From:  fromAddr,
		To:    &toAddr,
		Value: value,
		Data:  data,
	}

	return r.client.EstimateGas(r.ctx, msg)
}

// Close closes the RPC client connection
func (r *RPCClient) Close() {
	r.client.Close()
}

func main() {
	fmt.Println("🌐 Ethereum RPC Client\n")

	// Connect to Ethereum node (using public endpoint)
	rpcURL := "https://eth.llamarpc.com"
	client, err := NewRPCClient(rpcURL)
	if err != nil {
		log.Fatal(err)
	}
	defer client.Close()

	fmt.Printf("Connected to: %s\n\n", rpcURL)

	// Get chain ID
	chainID, err := client.GetChainID()
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("Chain ID: %s\n", chainID.String())

	// Get latest block number
	blockNumber, err := client.GetBlockNumber()
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("Latest Block: %d\n", blockNumber)

	// Get block details
	block, err := client.GetBlock(big.NewInt(int64(blockNumber)))
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("\n📦 Block Information:\n")
	fmt.Printf("   Number: %d\n", block.Number())
	fmt.Printf("   Hash: %s\n", block.Hash().Hex())
	fmt.Printf("   Timestamp: %d\n", block.Time())
	fmt.Printf("   Transactions: %d\n", len(block.Transactions()))
	fmt.Printf("   Gas Used: %d\n", block.GasUsed())
	fmt.Printf("   Gas Limit: %d\n", block.GasLimit())

	if block.BaseFee() != nil {
		fmt.Printf("   Base Fee: %s wei\n", block.BaseFee().String())
	}

	// Get gas price
	gasPrice, err := client.GetGasPrice()
	if err != nil {
		log.Fatal(err)
	}

	gasPriceGwei := new(big.Float).Quo(
		new(big.Float).SetInt(gasPrice),
		big.NewFloat(1e9),
	)
	fmt.Printf("\n⛽ Gas Price: %.2f gwei\n", gasPriceGwei)

	// Check balance for Vitalik's address
	vitalikAddress := "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"
	balance, err := client.GetBalance(vitalikAddress)
	if err != nil {
		log.Fatal(err)
	}

	balanceEth := new(big.Float).Quo(
		new(big.Float).SetInt(balance),
		big.NewFloat(1e18),
	)

	fmt.Printf("\n💰 Balance for %s\n", vitalikAddress)
	fmt.Printf("   %s ETH\n", balanceEth.Text('f', 6))

	// Get nonce
	nonce, err := client.GetNonce(vitalikAddress)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("   Nonce: %d\n", nonce)

	// Show some transactions from latest block
	if len(block.Transactions()) > 0 {
		fmt.Printf("\n📤 Recent Transactions (first 3):\n")

		for i, tx := range block.Transactions() {
			if i >= 3 {
				break
			}

			fmt.Printf("\n   Tx %d:\n", i+1)
			fmt.Printf("   Hash: %s\n", tx.Hash().Hex())
			fmt.Printf("   Value: %s wei\n", tx.Value().String())
			fmt.Printf("   Gas: %d\n", tx.Gas())

			if tx.To() != nil {
				fmt.Printf("   To: %s\n", tx.To().Hex())
			} else {
				fmt.Printf("   To: Contract Creation\n")
			}
		}
	}

	fmt.Println("\n✓ Done!")
}
