# Whitespace - The Invisible Programming Language

## Overview

**Whitespace** is an esoteric programming language created by Edwin Brady and Chris Morris in 2003. The language uses only three characters: space, tab, and line feed. All other characters are ignored, making the source code invisible in most editors.

## Language Features

- **3 Characters**: Space, Tab, Linefeed (all other characters are comments)
- **Stack-based**: Uses a stack for operations
- **Turing Complete**: Can compute anything computable
- **Invisible Code**: Source appears blank in most editors

### Character Encoding

| Character | Representation |
|-----------|----------------|
| Space | `[Space]` |
| Tab | `[Tab]` |
| Line Feed | `[LF]` |

### Instruction Set

#### Stack Manipulation (Space prefix)
- `[Space][Space]` - Push number
- `[Space][LF][Space]` - Duplicate top
- `[Space][LF][Tab]` - Swap top two

#### Arithmetic (Tab Space prefix)
- `[Tab][Space][Space][Space]` - Addition
- `[Tab][Space][Space][Tab]` - Subtraction
- `[Tab][Space][Space][LF]` - Multiplication

#### I/O (Tab LF prefix)
- `[Tab][LF][Space][Space]` - Output character
- `[Tab][LF][Space][Tab]` - Output number
- `[Tab][LF][Tab][Space]` - Read character
- `[Tab][LF][Tab][Tab]` - Read number

## Examples in This Directory

### 1. **Hello World** (`hello_world.ws`)
Outputs "Hello World!" using only whitespace characters.

**Visible Representation**:
```
[Space][Space][Space][Tab][Space][Space][Tab][Space][Tab][LF]  ; Push 72 ('H')
[Tab][LF][Space][Space]                                          ; Output character
[Space][Space][Space][Tab][Tab][Space][Tab][Tab][Space][Space][LF] ; Push 101 ('e')
[Tab][LF][Space][Space]                                          ; Output character
...
```

### 2. **Counter** (`counter.ws`)
A simple counter demonstrating loops and arithmetic.

## Running Whitespace Programs

### Online Interpreters
- [vii5ard.github.io/whitespace](https://vii5ard.github.io/whitespace/)
- [whitespace-interpreter](https://ideone.com/)

### Local Installation

#### Python Implementation
```bash
# Clone whitespace interpreter
git clone https://github.com/wspace/whitespace-python.git
cd whitespace-python

# Run a program
python3 whitespace.py hello_world.ws
```

#### Haskell Implementation
```bash
# Install with cabal
cabal install whitespace

# Run a program
whitespace hello_world.ws
```

### Node.js Implementation
```bash
npm install -g whitespace-lang
ws-run hello_world.ws
```

## Viewing Whitespace Code

Since whitespace is invisible, use these techniques to view the actual code:

### Method 1: Replace with Visible Characters
```bash
cat hello_world.ws | sed 's/ /[S]/g;s/\t/[T]/g;s/$/[LF]/' | head -20
```

### Method 2: Hexdump
```bash
hexdump -C hello_world.ws | head -20
```

### Method 3: Python Viewer
```python
with open('hello_world.ws', 'r') as f:
    content = f.read()
    visible = content.replace(' ', '[S]').replace('\t', '[T]').replace('\n', '[LF]\n')
    print(visible)
```

## Web3 Connection

Whitespace demonstrates interesting blockchain concepts:

1. **Hidden State**: Like private keys, the code is invisible but functional
2. **Minimalism**: Similar to optimized smart contracts (gas efficiency)
3. **Binary Nature**: Reflects how data is stored on-chain
4. **Verification**: Need tools to verify what you can't see (like contract verification)

## Programming Concepts

### Number Representation
Numbers are binary in Whitespace:
- `[Space]` = 0
- `[Tab]` = 1
- `[LF]` = End of number

Example: Push number 5
```
[Space][Space][Tab][Space][Tab][LF]
```
= Binary: 101 = Decimal: 5

### Stack Operations
```
Stack: [Top] -> [Bottom]

Push 5:  [5]
Push 3:  [3, 5]
Add:     [8]
Output:  [] (prints 8)
```

### Labels and Flow Control
```
[LF][Space][Space] (label)    ; Mark location
[LF][Space][Tab] (call)       ; Call subroutine
[LF][Space][LF] (jump)        ; Unconditional jump
[LF][Tab][Space] (jump-zero)  ; Jump if top is zero
```

## Advanced Example: Fibonacci

```whitespace
[Space][Space][Space][Tab][LF]           ; Push 1
[Space][Space][Space][Tab][LF]           ; Push 1
[LF][Space][Space][Space][Tab][Tab][LF]  ; Label: loop
[Space][LF][Space]                        ; Duplicate
[Tab][LF][Space][Tab]                     ; Print number
[Space][LF][Space]                        ; Duplicate
[Tab][Space][Space][Space]                ; Add
```

## Project Context

Part of **EchoScroll's** esoteric language collection. Whitespace shows that:
- Programming languages can challenge conventions
- Visibility ≠ Functionality
- Minimalism can be taken to extremes

## Security Considerations

Whitespace code can be hidden in:
- Comments of other languages
- Trailing whitespace
- Seemingly empty files

This makes it interesting for:
- Steganography
- Code obfuscation
- Educational purposes

## Resources

- [Whitespace Tutorial](https://web.archive.org/web/20150618184706/http://compsoc.dur.ac.uk/whitespace/tutorial.php)
- [Whitespace Corpus](https://github.com/wspace/corpus)
- [Esolang Whitespace](https://esolangs.org/wiki/Whitespace)

## Fun Facts

- Created as an April Fools' joke
- Has a full implementation in Haskell
- Some IDEs accidentally break Whitespace code by removing trailing whitespace
- There's a Whitespace assembler called `wsa`

---

**Difficulty**: 🔴🔴🔴🔴🔴 Extremely Hard
**Practical Use**: Educational/Steganography
**Turing Complete**: ✅ Yes
**Lines of Code**: Invisible! 👻


*Last updated: 2025-11-14*
