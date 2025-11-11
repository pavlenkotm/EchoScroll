# LOLCODE - Internet Meme Programming Language

## Overview

**LOLCODE** is an esoteric programming language designed to resemble the broken English of lolcats internet memes. Created by Adam Lindsay in 2007, it's both humorous and Turing-complete.

## Language Features

- **Meme-based Syntax**: Based on LOLcat speak
- **Human Readable**: Despite being silly, it's quite readable
- **Turing Complete**: Can compute anything computable
- **Fun**: Makes programming entertaining

### Basic Syntax

| LOLCODE | Translation | Description |
|---------|-------------|-------------|
| `HAI` | Hello | Start program |
| `KTHXBYE` | OK Thanks Bye | End program |
| `CAN HAS` | Can has | Import library |
| `VISIBLE` | Visible | Print output |
| `GIMMEH` | Give me | Input |
| `I HAS A` | I has a | Variable declaration |
| `ITZ` | It's | Assignment |
| `O RLY?` | Oh really? | If statement |
| `YA RLY` | Yeah really | Then |
| `NO WAI` | No way | Else |
| `OIC` | Oh I see | End if |
| `BTW` | By the way | Comment |

## Examples in This Directory

### 1. **Hello World** (`hello_world.lol`)
Classic greeting in LOLCODE.

```lolcode
HAI 1.2
  CAN HAS STDIO?
  VISIBLE "HAI WORLD!"
KTHXBYE
```

**Output**: `HAI WORLD!`

### 2. **Web3 Wallet** (`web3_wallet.lol`)
Simulates a Web3 wallet with balance and transactions.

**Features**:
- Wallet address display
- Balance checking
- Transaction simulation
- Balance updates
- Transaction hash generation

### 3. **Smart Contract** (`smart_contract.lol`)
Simulates the EchoScroll smart contract functionality.

**Features**:
- Scroll publishing
- Scroll counter
- Deletion spell casting
- Event emission
- Conditional logic

## Running LOLCODE Programs

### Online Interpreters
- [replit.com](https://replit.com/languages/lolcode)
- [tio.run](https://tio.run/#lolcode)

### Local Installation

#### Official Interpreter (Python)
```bash
# Clone the repository
git clone https://github.com/justinmeza/lci.git
cd lci

# Build
cmake .
make

# Run
./lci hello_world.lol
```

#### Node.js Implementation
```bash
npm install -g lolcode
lolcode hello_world.lol
```

#### Python Implementation
```bash
pip install lolpython
lolpython hello_world.lol
```

## Language Constructs

### Variables
```lolcode
I HAS A VAR           BTW Declare
VAR R 5               BTW Assign
I HAS A VAR ITZ 5     BTW Declare and assign
```

### Types
```lolcode
I HAS A NUMBR ITZ 42          BTW Integer
I HAS A NUMBAR ITZ 3.14       BTW Float
I HAS A YARN ITZ "hai"        BTW String
I HAS A TROOF ITZ WIN         BTW Boolean (WIN/FAIL)
```

### Arithmetic
```lolcode
SUM OF 2 AN 3          BTW Addition (5)
DIFF OF 10 AN 3        BTW Subtraction (7)
PRODUKT OF 4 AN 5      BTW Multiplication (20)
QUOSHUNT OF 10 AN 2    BTW Division (5)
MOD OF 10 AN 3         BTW Modulo (1)
```

### Comparison
```lolcode
BOTH SAEM 5 AN 5       BTW Equal (WIN)
DIFFRINT 5 AN 3        BTW Not equal (WIN)
BIGGR OF 5 AN 3        BTW Greater (5)
SMALLR OF 5 AN 3       BTW Lesser (3)
```

### Loops
```lolcode
IM IN YR LOOP
  BTW Loop body
  BOTH SAEM COUNT AN 10, O RLY?
    YA RLY
      GTFO     BTW Break
  OIC
IM OUTTA YR LOOP
```

### Functions
```lolcode
HOW IZ I FUNCTIONNAME YR ARG1 AN YR ARG2
  BTW Function body
  FOUND YR RESULT      BTW Return
IF U SAY SO

BTW Call function
I IZ FUNCTIONNAME YR 5 AN YR 10 MKAY
```

## Web3 Connection

Our LOLCODE examples demonstrate Web3 concepts:

1. **Wallet Management**: Address handling, balance tracking
2. **Transactions**: Sending, receiving, transaction hashes
3. **Smart Contracts**: State management, functions, events
4. **Blockchain Operations**: Read/write operations, state changes

## Advanced Example: Token Balance

```lolcode
HAI 1.2
  CAN HAS STDIO?

  BTW ERC-20 Token Balance Checker
  I HAS A TOKEN_NAME ITZ "EchoToken"
  I HAS A TOKEN_SYMBOL ITZ "ECHO"
  I HAS A DECIMALS ITZ 18

  BTW Balance mapping (simplified)
  I HAS A ADDR1_BAL ITZ 1000
  I HAS A ADDR2_BAL ITZ 500

  VISIBLE "TOKEN: :TOKEN_NAME (:TOKEN_SYMBOL)"
  VISIBLE "DECIMALS: :DECIMALS"
  VISIBLE ""

  BTW Transfer function
  VISIBLE "TRANSFERIN 100 TOKENSS..."

  I HAS A AMOUNT ITZ 100

  BTW Check sufficient balance
  BIGGR OF ADDR1_BAL AN AMOUNT, O RLY?
    YA RLY
      ADDR1_BAL R DIFF OF ADDR1_BAL AN AMOUNT
      ADDR2_BAL R SUM OF ADDR2_BAL AN AMOUNT
      VISIBLE "SUCCESS! TRANSFERD :AMOUNT TOKENSS"
    NO WAI
      VISIBLE "FAIL! INSUFFICIENT BALANCE"
  OIC

  VISIBLE ""
  VISIBLE "NEW BALANCES:"
  VISIBLE "  ADDR1: :ADDR1_BAL :TOKEN_SYMBOL"
  VISIBLE "  ADDR2: :ADDR2_BAL :TOKEN_SYMBOL"

KTHXBYE
```

## Project Context

Part of **EchoScroll's** esoteric language collection. LOLCODE demonstrates:
- Programming can be fun and accessible
- Syntax is arbitrary
- Humor doesn't preclude functionality
- Internet culture influence on tech

## Code Quality

Despite its humorous nature, LOLCODE programs can be:
- Well-structured
- Readable (in their own way)
- Properly documented with BTW comments
- Educational

## Resources

- [LOLCODE Official Site](http://www.lolcode.org/)
- [LOLCODE Specification](https://github.com/justinmeza/lolcode-spec/blob/master/v1.2/lolcode-spec-v1.2.md)
- [Esolang LOLCODE](https://esolangs.org/wiki/LOLCODE)
- [LOLCODE GitHub](https://github.com/justinmeza/lci)

## Fun Facts

- Created by Adam Lindsay in 2007
- Has implementations in multiple languages
- Featured in numerous programming language lists
- Has been used to teach basic programming concepts
- There's a LOLCODE to C compiler

## Community

- Active GitHub community
- Regular contributions
- Educational usage
- Meme integration continues

---

**Difficulty**: 🟡🟡⚪⚪⚪ Easy (once you learn the syntax)
**Practical Use**: Educational/Entertainment
**Turing Complete**: ✅ Yes
**Readability**: 😹 Very meme
