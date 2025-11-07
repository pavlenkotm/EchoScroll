package main

import (
	"crypto/ecdsa"
	"encoding/hex"
	"fmt"
	"log"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/common/hexutil"
	"github.com/ethereum/go-ethereum/crypto"
)

// SignatureVerifier handles Ethereum signature verification
type SignatureVerifier struct{}

// NewSignatureVerifier creates a new verifier instance
func NewSignatureVerifier() *SignatureVerifier {
	return &SignatureVerifier{}
}

// VerifySignature verifies an Ethereum signature
func (sv *SignatureVerifier) VerifySignature(
	message string,
	signature string,
	expectedAddress string,
) (bool, error) {
	// Hash the message using Ethereum's signing prefix
	messageHash := sv.HashMessage(message)

	// Decode signature
	sigBytes, err := hexutil.Decode(signature)
	if err != nil {
		return false, fmt.Errorf("invalid signature format: %v", err)
	}

	// Ethereum signatures have v value of 27 or 28, we need 0 or 1
	if sigBytes[64] >= 27 {
		sigBytes[64] -= 27
	}

	// Recover public key from signature
	pubKey, err := crypto.SigToPub(messageHash, sigBytes)
	if err != nil {
		return false, fmt.Errorf("failed to recover public key: %v", err)
	}

	// Get address from public key
	recoveredAddress := crypto.PubkeyToAddress(*pubKey)

	// Compare with expected address
	expected := common.HexToAddress(expectedAddress)

	return recoveredAddress == expected, nil
}

// HashMessage creates an Ethereum signed message hash
func (sv *SignatureVerifier) HashMessage(message string) []byte {
	// Ethereum signed message format: "\x19Ethereum Signed Message:\n" + len(message) + message
	prefix := fmt.Sprintf("\x19Ethereum Signed Message:\n%d%s", len(message), message)
	return crypto.Keccak256([]byte(prefix))
}

// RecoverAddress recovers the signer's address from a signature
func (sv *SignatureVerifier) RecoverAddress(message string, signature string) (string, error) {
	messageHash := sv.HashMessage(message)

	sigBytes, err := hexutil.Decode(signature)
	if err != nil {
		return "", fmt.Errorf("invalid signature: %v", err)
	}

	if sigBytes[64] >= 27 {
		sigBytes[64] -= 27
	}

	pubKey, err := crypto.SigToPub(messageHash, sigBytes)
	if err != nil {
		return "", fmt.Errorf("recovery failed: %v", err)
	}

	address := crypto.PubkeyToAddress(*pubKey)
	return address.Hex(), nil
}

// GenerateKeyPair generates a new Ethereum key pair
func GenerateKeyPair() (*ecdsa.PrivateKey, string, error) {
	privateKey, err := crypto.GenerateKey()
	if err != nil {
		return nil, "", err
	}

	address := crypto.PubkeyToAddress(privateKey.PublicKey)
	return privateKey, address.Hex(), nil
}

// SignMessage signs a message with a private key
func SignMessage(message string, privateKey *ecdsa.PrivateKey) (string, error) {
	verifier := NewSignatureVerifier()
	messageHash := verifier.HashMessage(message)

	signature, err := crypto.Sign(messageHash, privateKey)
	if err != nil {
		return "", err
	}

	return hexutil.Encode(signature), nil
}

func main() {
	fmt.Println("🔐 Ethereum Signature Verifier\n")

	// Generate a new key pair
	privateKey, address, err := GenerateKeyPair()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Generated Address: %s\n", address)
	fmt.Printf("Private Key: %s\n\n", hex.EncodeToString(crypto.FromECDSA(privateKey)))

	// Sign a message
	message := "Hello, Ethereum!"
	signature, err := SignMessage(message, privateKey)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Message: %s\n", message)
	fmt.Printf("Signature: %s\n\n", signature)

	// Verify the signature
	verifier := NewSignatureVerifier()

	valid, err := verifier.VerifySignature(message, signature, address)
	if err != nil {
		log.Fatal(err)
	}

	if valid {
		fmt.Println("✓ Signature is valid!")
	} else {
		fmt.Println("✗ Signature is invalid!")
	}

	// Recover address from signature
	recoveredAddress, err := verifier.RecoverAddress(message, signature)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("\nRecovered Address: %s\n", recoveredAddress)
	fmt.Printf("Expected Address: %s\n", address)

	if recoveredAddress == address {
		fmt.Println("\n✓ Address recovery successful!")
	}

	// Example with wrong signature
	fmt.Println("\n" + "="*50)
	fmt.Println("Testing with wrong address...")

	wrongAddress := "0x0000000000000000000000000000000000000000"
	valid, _ = verifier.VerifySignature(message, signature, wrongAddress)

	if !valid {
		fmt.Println("✓ Correctly identified invalid signature")
	}
}
