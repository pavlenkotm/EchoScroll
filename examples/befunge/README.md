# Befunge - 2D Programming Language

## Overview

**Befunge** is a two-dimensional esoteric programming language created by Chris Pressey in 1993. Unlike traditional languages that execute line-by-line, Befunge programs execute on a 2D grid where the instruction pointer can move in four directions: up, down, left, and right.

## Language Features

- **2D Grid**: Code is laid out on a 2D plane
- **Stack-based**: Uses a stack for data manipulation
- **Self-modifying**: Can modify its own code during execution
- **Four Directions**: Instruction pointer moves up/down/left/right
- **Turing Complete**: Can compute anything computable

### Befunge-93 vs Befunge-98

- **Befunge-93**: Original version, 80x25 grid
- **Befunge-98**: Extended version, unbounded grid

### Basic Commands

| Command | Description |
|---------|-------------|
| `0-9` | Push digit onto stack |
| `+` | Addition |
| `-` | Subtraction |
| `*` | Multiplication |
| `/` | Division |
| `%` | Modulo |
| `:` | Duplicate top of stack |
| `\` | Swap top two stack items |
| `$` | Pop value from stack |
| `!` | Logical NOT |
| `` ` `` | Greater than |
| `>` | Move right |
| `<` | Move left |
| `^` | Move up |
| `v` | Move down |
| `?` | Random direction |
| `_` | Horizontal if (pop: right if 0, left if not) |
| `\|` | Vertical if (pop: down if 0, up if not) |
| `"` | Toggle string mode |
| `,` | Pop and output as character |
| `.` | Pop and output as number |
| `&` | Input number |
| `~` | Input character |
| `@` | End program |
| `#` | Bridge (skip next cell) |

## Examples in This Directory

### 1. **Hello World** (`hello_world.bf93`)
Classic greeting in 2D.

```befunge
"!dlroW olleH">:#,_@
```

**Explanation**:
1. `"!dlroW olleH"` - Pushes string backwards onto stack
2. `>` - Move right
3. `:` - Duplicate top of stack
4. `#` - Skip next cell
5. `,` - Output character
6. `_` - Horizontal if: continue if stack not empty
7. `@` - End when stack empty

### 2. **Counter** (`counter.bf93`)
Counts from 0 to 9 vertically.

```befunge
0>:1+:9`#@_:.v
             <
```

**Explanation**:
- Line 1: Count up, compare with 9, output, move down
- Line 2: Loop back to top

### 3. **Blockchain Hash** (`blockchain_hash.bf93`)
Outputs "Block" and "Bich" simulating hash operations.

## Running Befunge Programs

### Online Interpreters
- [copy.sh/befunge](https://copy.sh/befunge/)
- [befunge.flogisoft.com](http://befunge.flogisoft.com/)
- [befunge93.herokuapp.com](https://befunge93.herokuapp.com/)

### Local Installation

#### Python Implementation (PyFunge)
```bash
pip install pyfunge
pyfunge hello_world.bf93
```

#### C Implementation (BefungeSharp)
```bash
# Clone repository
git clone https://github.com/serprex/befunge
cd befunge
make

# Run
./befunge hello_world.bf93
```

#### Node.js Implementation
```bash
npm install -g befunge93
befunge93 hello_world.bf93
```

## Programming Concepts

### Program Flow

```
Start → → → → → →
↓             ↑
↓   Loop  ← ← ↑
↓             ↑
→ → → → End @ ↑
```

### Stack Operations

```befunge
5 3 + .@    Outputs: 8
```
- Push 5
- Push 3
- Add (pops 3 and 5, pushes 8)
- Output as number
- End

### String Output

```befunge
"Hello">:#,_@
```
- `"Hello"` pushes 'o', 'l', 'l', 'e', 'H' onto stack
- `>` move right
- `:` duplicate top
- `#` skip `,`
- `,` output character (executed on second pass)
- `_` continue if not zero
- `@` end when zero

### Loops

Horizontal loop:
```befunge
>01-:v
    @>
```

Vertical loop:
```befunge
v
>
^
```

### Conditionals

```befunge
5 3 ` v
     >".eurt"v
           >@
     >".eslaf"v
              >@
```

## Advanced Example: Fibonacci

```befunge
>1:.:>:0`#@_:v
 ^+1,*25:<
```

**Explanation**:
1. Start with 1
2. Duplicate and output
3. Add previous value
4. Check if less than max
5. Loop or end

## Web3 Connection

Befunge demonstrates blockchain concepts:

1. **2D Grid**: Like blockchain's multi-dimensional data structure
2. **Self-modification**: Similar to upgradeable contracts
3. **State Machine**: Grid represents state, pointer represents transitions
4. **Deterministic**: Same input always produces same output

## Advanced Example: Simple Smart Contract

```befunge
v"Contract"  < Initialize
>:#,_$       v Output
 "State"     v
>:#,_$       v
 "Balance"   v
>:#,_$       @
```

## Playfield Manipulation

Befunge can modify its own code:

```befunge
"A"01p  Put 'A' at position (0,1)
01g,@   Get character at (0,1) and output
```

### `p` - Put
`p` pops y, x, v and stores v at (x, y)

### `g` - Get
`g` pops y, x and pushes value at (x, y)

## Project Context

Part of **EchoScroll's** esoteric language collection. Befunge demonstrates:
- Programming doesn't have to be linear
- 2D thinking in problem-solving
- Creative approaches to computation
- Visual representation of logic flow

## Debugging Befunge

Visual execution is key:

```
Step 1: "Hello"
Stack: [H][e][l][l][o]

Step 2: >
Direction: Right

Step 3: :
Stack: [H][e][l][l][o][o]

Step 4: #,
Output: o
Stack: [H][e][l][l][o]
```

## Tips for Writing Befunge

1. **Plan the Grid**: Sketch layout first
2. **Use Bridges**: `#` to skip unwanted cells
3. **Direction Control**: Plan pointer movement
4. **Stack Management**: Track stack state
5. **Test Small**: Build incrementally

## Resources

- [Befunge-93 Spec](https://github.com/catseye/Befunge-93)
- [Esolang Befunge](https://esolangs.org/wiki/Befunge)
- [Befunge Tutorial](https://quadium.net/funge/tutorial.html)
- [Funge-98 Spec](https://github.com/catseye/Funge-98)

## Fun Facts

- Created to be as difficult to compile as possible
- Name is a portmanteau of "Before" and "Funge"
- Has inspired many 2D languages (><>, Cardinal, etc.)
- Used in code golf competitions
- Some roguelike games use Befunge-like grids

## Variants

- **Unefunge**: 1D version
- **Trefunge**: 3D version
- **><>**: Fish-themed variant
- **Cardinal**: Extended Befunge

## Community

- Active esolang community
- Code golf enthusiasts
- Visual programming advocates
- Education and research

---

**Difficulty**: 🔴🔴🔴🔴⚪ Very Hard
**Practical Use**: Educational/Puzzle
**Turing Complete**: ✅ Yes
**Dimensions**: 📐 2D
**Unique Factor**: 🎯 Extremely High
