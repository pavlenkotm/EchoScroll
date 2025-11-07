# Makefile for EchoScroll

.PHONY: help install build test deploy clean

help:
\t@echo "Available commands:"
\t@echo "  make install  - Install dependencies"
\t@echo "  make build    - Build the project"
\t@echo "  make test     - Run tests"
\t@echo "  make deploy   - Deploy contracts"
\t@echo "  make clean    - Clean build artifacts"

install:
\tnpm install

build:
\tnpx hardhat compile
\tnpm run build

test:
\tnpx hardhat test

deploy:
\tnpx hardhat deploy --network zksync-sepolia

clean:
\trm -rf node_modules .next dist build

