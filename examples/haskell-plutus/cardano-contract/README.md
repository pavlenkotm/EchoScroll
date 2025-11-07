# Haskell Plutus Smart Contract

## Overview

A simple Plutus validator for Cardano blockchain written in Haskell. Demonstrates password-protected script addresses on Cardano.

## About Plutus

**Plutus** is the smart contract platform for Cardano. Written in Haskell, it provides:
- Strong type safety
- Formal verification capabilities
- EUTXO model (Extended UTXO)
- On-chain and off-chain code sharing

## Features

- ✅ Password-protected validator
- ✅ Datum and redeemer pattern
- ✅ Type-safe script compilation
- ✅ Script address derivation
- ✅ Helper functions for testing

## Contract Logic

The validator checks if the password in the redeemer matches the password in the datum:

```haskell
mkValidator datum redeemer ctx =
    password datum == guess redeemer
```

## Setup

### Prerequisites

- GHC 8.10.7+
- Cabal 3.6+
- Plutus dependencies

### Install Nix

```bash
curl -L https://nixos.org/nix/install | sh
```

### Build

```bash
cabal update
cabal build
```

## Usage

### Lock Funds

```haskell
-- Create datum with password
let datum = mkDatum "secret123"

-- Send ADA to script address
-- with the datum attached
```

### Unlock Funds

```haskell
-- Create redeemer with correct password
let redeemer = mkRedeemer "secret123"

-- Submit transaction to unlock funds
-- Validator will check: password datum == guess redeemer
```

## Testing

Run in Plutus Playground:
1. Visit [Plutus Playground](https://playground.plutus.iohkdev.io/)
2. Copy contract code
3. Simulate locking and unlocking

## Deployment

Deploy to Cardano testnet:

```bash
cardano-cli transaction build \
  --tx-in <UTXO> \
  --tx-out <SCRIPT_ADDRESS>+<AMOUNT> \
  --tx-out-datum-hash <DATUM_HASH> \
  --change-address <YOUR_ADDRESS> \
  --testnet-magic 1 \
  --out-file tx.raw

cardano-cli transaction sign \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --testnet-magic 1 \
  --out-file tx.signed

cardano-cli transaction submit \
  --tx-file tx.signed \
  --testnet-magic 1
```

## Key Concepts

### UTXO Model

Cardano uses the UTXO (Unspent Transaction Output) model with script validation.

### Datum

Data attached to a UTXO at a script address.

### Redeemer

Input provided when spending a UTXO from a script address.

### Script Context

Information about the transaction being validated.

## Resources

- [Plutus Documentation](https://plutus.readthedocs.io/)
- [Cardano Developers](https://developers.cardano.org/)
- [Plutus Pioneer Program](https://github.com/input-output-hk/plutus-pioneer-program)

## Security

⚠️ Educational example only. For production:
- Use proper cryptographic methods
- Add comprehensive validation logic
- Implement time locks
- Test extensively
- Get professional audit

## License

MIT
