{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE DeriveAnyClass      #-}
{-# LANGUAGE DeriveGeneric       #-}
{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE NoImplicitPrelude   #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell     #-}
{-# LANGUAGE TypeApplications    #-}
{-# LANGUAGE TypeFamilies        #-}
{-# LANGUAGE TypeOperators       #-}

module SimpleValidator where

import qualified PlutusTx
import           PlutusTx.Prelude hiding (Semigroup(..), unless)
import           Ledger hiding (singleton)
import           Ledger.Typed.Scripts as Scripts
import qualified Ledger.Ada as Ada
import           Plutus.V2.Ledger.Api
import           Plutus.V2.Ledger.Contexts
import qualified Prelude as P

-- | Simple datum for our validator
newtype SimpleDatum = SimpleDatum
    { password :: BuiltinByteString
    }

PlutusTx.unstableMakeIsData ''SimpleDatum

-- | Redeemer for unlocking funds
newtype SimpleRedeemer = SimpleRedeemer
    { guess :: BuiltinByteString
    }

PlutusTx.unstableMakeIsData ''SimpleRedeemer

{-# INLINABLE mkValidator #-}
-- | The validator script
-- Checks if the provided password matches the datum
mkValidator :: SimpleDatum -> SimpleRedeemer -> ScriptContext -> Bool
mkValidator datum redeemer ctx =
    traceIfFalse "Wrong password!" passwordMatches
  where
    passwordMatches :: Bool
    passwordMatches = password datum == guess redeemer

-- | The typed validator interface
data SimpleTyped
instance Scripts.ValidatorTypes SimpleTyped where
    type instance DatumType SimpleTyped = SimpleDatum
    type instance RedeemerType SimpleTyped = SimpleRedeemer

-- | Compile the validator to Plutus Core
typedValidator :: Scripts.TypedValidator SimpleTyped
typedValidator = Scripts.mkTypedValidator @SimpleTyped
    $$(PlutusTx.compile [|| mkValidator ||])
    $$(PlutusTx.compile [|| wrap ||])
  where
    wrap = Scripts.mkUntypedValidator

-- | The validator script
validator :: Validator
validator = Scripts.validatorScript typedValidator

-- | The validator hash
valHash :: Ledger.ValidatorHash
valHash = Scripts.validatorHash typedValidator

-- | The script address
scrAddress :: Ledger.Address
scrAddress = scriptAddress validator

{-

This is a simple Plutus validator for Cardano that:

1. Accepts a datum containing a password (BuiltinByteString)
2. Requires a redeemer with a password guess
3. Validates that the guess matches the password in the datum
4. If they match, funds can be unlocked from the script address

Usage:
- Lock funds at script address with a password datum
- Unlock by providing correct password in redeemer

Example:
- Datum: SimpleDatum { password = "secret123" }
- Redeemer: SimpleRedeemer { guess = "secret123" }
- Result: ✓ Funds unlocked

Security Note:
This is a educational example. In production:
- Use proper cryptographic hashing
- Implement time locks
- Add additional validation logic
- Consider using reference scripts
- Test extensively on testnet

-}

-- | Helper function to create a datum
mkDatum :: P.String -> SimpleDatum
mkDatum pwd = SimpleDatum
    { password = toBuiltin $ P.encodeUtf8 pwd
    }

-- | Helper function to create a redeemer
mkRedeemer :: P.String -> SimpleRedeemer
mkRedeemer pwd = SimpleRedeemer
    { guess = toBuiltin $ P.encodeUtf8 pwd
    }
