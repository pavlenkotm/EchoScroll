/**
 * Yul - Low-Level EVM Language
 * A simple storage contract demonstrating Yul's inline assembly capabilities
 * Yul compiles directly to EVM bytecode for maximum gas efficiency
 */

object "StorageContract" {
    code {
        // Deploy the contract
        datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
        return(0, datasize("Runtime"))
    }

    object "Runtime" {
        code {
            // Contract dispatcher
            // Get function selector (first 4 bytes of calldata)
            let selector := shr(224, calldataload(0))

            // store(uint256) - 0x60fe47b1
            if eq(selector, 0x60fe47b1) {
                let value := calldataload(4)
                sstore(0, value)

                // Emit event: Stored(uint256 value)
                mstore(0, value)
                log1(0, 32, 0x7f8661a1d0b66a0c21b5f1d8b0b3e0d8a19a2a2b3c3d4e4f5a5b6c6d7e7f8889)

                return(0, 0)
            }

            // retrieve() - 0x2e64cec1
            if eq(selector, 0x2e64cec1) {
                let value := sload(0)
                mstore(0, value)
                return(0, 32)
            }

            // increment() - 0xd09de08a
            if eq(selector, 0xd09de08a) {
                let value := sload(0)
                let newValue := add(value, 1)

                // Check overflow
                if lt(newValue, value) {
                    revert(0, 0)
                }

                sstore(0, newValue)
                mstore(0, newValue)
                return(0, 32)
            }

            // decrement() - 0x2baeceb7
            if eq(selector, 0x2baeceb7) {
                let value := sload(0)

                // Check underflow
                if eq(value, 0) {
                    revert(0, 0)
                }

                let newValue := sub(value, 1)
                sstore(0, newValue)
                mstore(0, newValue)
                return(0, 32)
            }

            // addTo(uint256) - 0x121b93f5
            if eq(selector, 0x121b93f5) {
                let value := sload(0)
                let amount := calldataload(4)
                let newValue := add(value, amount)

                // Check overflow
                if lt(newValue, value) {
                    revert(0, 0)
                }

                sstore(0, newValue)
                mstore(0, newValue)
                return(0, 32)
            }

            // multiply(uint256) - 0xc8a4ac9c
            if eq(selector, 0xc8a4ac9c) {
                let value := sload(0)
                let multiplier := calldataload(4)

                // Prevent overflow: if value > 0, check that multiplier <= MAX_UINT256 / value
                if gt(value, 0) {
                    let maxMultiplier := div(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, value)
                    if gt(multiplier, maxMultiplier) {
                        revert(0, 0)
                    }
                }

                let newValue := mul(value, multiplier)
                sstore(0, newValue)
                mstore(0, newValue)
                return(0, 32)
            }

            // reset() - 0xd826f88f
            if eq(selector, 0xd826f88f) {
                sstore(0, 0)
                return(0, 0)
            }

            // Default: revert if function not found
            revert(0, 0)
        }
    }
}

/**
 * Function Signatures:
 *
 * store(uint256): 0x60fe47b1
 * retrieve(): 0x2e64cec1
 * increment(): 0xd09de08a
 * decrement(): 0x2baeceb7
 * addTo(uint256): 0x121b93f5
 * multiply(uint256): 0xc8a4ac9c
 * reset(): 0xd826f88f
 *
 * Usage with cast:
 * cast send <CONTRACT> "store(uint256)" 42
 * cast call <CONTRACT> "retrieve()"
 * cast send <CONTRACT> "increment()"
 */
