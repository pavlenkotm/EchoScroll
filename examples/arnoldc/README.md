# ArnoldC - Programming Language Based on Arnold Schwarzenegger

## Overview

**ArnoldC** is an esoteric programming language where all keywords are replaced with quotes from Arnold Schwarzenegger movies. Created by Lauri Hartikka in 2013, it's a tribute to the action movie star and his memorable one-liners.

## Language Features

- **Movie Quotes**: All keywords are Arnold quotes
- **Imperative**: Procedural programming style
- **Java-based**: Compiles to Java bytecode
- **Turing Complete**: Can compute anything computable
- **Entertaining**: Makes coding feel like an action movie

### Keyword Translation

| ArnoldC | Regular Language | Quote From |
|---------|-----------------|------------|
| `IT'S SHOWTIME` | `main() {` | Various movies |
| `YOU HAVE BEEN TERMINATED` | `}` | The Terminator |
| `HEY CHRISTMAS TREE` | `int` variable | Jingle All The Way |
| `YOU SET US UP` | `=` assignment | Zero Wing (meme) |
| `GET TO THE CHOPPER` | Begin assignment | Predator |
| `HERE IS MY INVITATION` | Value reference | Various |
| `ENOUGH TALK` | End assignment | Various |
| `GET UP` | `+` | Various |
| `GET DOWN` | `-` | Various |
| `YOU'RE FIRED` | `*` | Various |
| `HE HAD TO SPLIT` | `/` | Various |
| `I LET HIM GO` | `%` modulo | Commando |
| `TALK TO THE HAND` | `print` | Terminator 3 |
| `STICK AROUND` | `while` | Various |
| `CHILL` | End while | Various |
| `BECAUSE I'M GOING TO SAY PLEASE` | `if` | Various |
| `BULLSHIT` | `else` | Various |
| `YOU HAVE NO RESPECT FOR LOGIC` | End if | Various |

## Examples in This Directory

### 1. **Hello World** (`hello_world.arnoldc`)
The classic greeting, Arnold style.

```arnoldc
IT'S SHOWTIME
TALK TO THE HAND "Hello World!"
YOU HAVE BEEN TERMINATED
```

**Output**: `Hello World!`

### 2. **Blockchain Counter** (`blockchain_counter.arnoldc`)
Simulates blockchain synchronization with block counting.

**Features**:
- Variable declaration
- Loop control
- Counter increment
- Conditional logic
- Block mining simulation

### 3. **Smart Contract** (`smart_contract.arnoldc`)
Simulates the EchoScroll smart contract operations.

**Features**:
- Scroll publishing
- Event emission
- State management
- Transaction logging
- Counter tracking

## Running ArnoldC Programs

### Installation

#### From GitHub
```bash
# Clone the repository
git clone https://github.com/lhartikk/ArnoldC.git
cd ArnoldC

# Build (requires Java and Maven)
mvn package

# Run a program
java -jar target/ArnoldC.jar hello_world.arnoldc
java hello_world
```

#### Using Docker
```bash
# Pull the image
docker pull sahilahmed/arnoldc

# Run a program
docker run -v $(pwd):/code sahilahmed/arnoldc hello_world.arnoldc
```

### Online Interpreters
- [ArnoldC Playground](https://paiza.io/en/projects/new?language=arnoldc)

## Language Constructs

### Variables
```arnoldc
HEY CHRISTMAS TREE myVar
YOU SET US UP 42
```

### Assignment
```arnoldc
GET TO THE CHOPPER myVar
HERE IS MY INVITATION 10
ENOUGH TALK
```

### Arithmetic
```arnoldc
GET TO THE CHOPPER result
HERE IS MY INVITATION 5
GET UP 3              @@ Add 3
ENOUGH TALK
@@ result = 8

GET TO THE CHOPPER result
HERE IS MY INVITATION 10
GET DOWN 2            @@ Subtract 2
ENOUGH TALK
@@ result = 8

GET TO THE CHOPPER result
HERE IS MY INVITATION 4
YOU'RE FIRED 5        @@ Multiply by 5
ENOUGH TALK
@@ result = 20
```

### Output
```arnoldc
TALK TO THE HAND "This is output"
TALK TO THE HAND myVar
```

### Loops (While)
```arnoldc
STICK AROUND condition
  @@ Loop body
  @@ Update condition
CHILL
```

### Conditionals
```arnoldc
BECAUSE I'M GOING TO SAY PLEASE condition
  @@ True branch
BULLSHIT
  @@ False branch
YOU HAVE NO RESPECT FOR LOGIC
```

### Comments
```arnoldc
@@ This is a comment
@@NO PROBLEMO This is also a comment
```

## Advanced Example: Factorial

```arnoldc
IT'S SHOWTIME

HEY CHRISTMAS TREE number
YOU SET US UP 5

HEY CHRISTMAS TREE result
YOU SET US UP 1

HEY CHRISTMAS TREE counter
YOU SET US UP 1

STICK AROUND counter
  GET TO THE CHOPPER result
  HERE IS MY INVITATION result
  YOU'RE FIRED counter
  ENOUGH TALK

  GET TO THE CHOPPER counter
  HERE IS MY INVITATION counter
  GET UP 1
  ENOUGH TALK

  GET TO THE CHOPPER counter
  HERE IS MY INVITATION counter
  LET OFF SOME STEAM BENNET number
  ENOUGH TALK
CHILL

TALK TO THE HAND "Factorial result: "
TALK TO THE HAND result

YOU HAVE BEEN TERMINATED
```

## Web3 Connection

Our ArnoldC examples demonstrate:

1. **Blockchain Operations**: Block mining, synchronization
2. **Smart Contracts**: State management, functions, events
3. **Transaction Processing**: Sequential operations
4. **Counter Systems**: Tracking state changes

## Project Context

Part of **EchoScroll's** esoteric language collection. ArnoldC shows:
- Keywords are arbitrary conventions
- Programming can be theatrical
- Movie culture meets tech
- Humor enhances learning

## Compilation Process

```bash
# Compile ArnoldC to Java
java -jar ArnoldC.jar program.arnoldc

# This creates program.java
# Compile to bytecode
javac program.java

# Run
java program
```

## Limitations

- No floating-point arithmetic
- Limited string operations
- Integer operations only
- Basic control structures
- No functions/procedures (only main)

## Resources

- [ArnoldC GitHub](https://github.com/lhartikk/ArnoldC)
- [ArnoldC Documentation](https://github.com/lhartikk/ArnoldC/wiki)
- [Esolang ArnoldC](https://esolangs.org/wiki/ArnoldC)

## Fun Facts

- Created in a single weekend
- Over 3000 GitHub stars
- Featured in numerous programming lists
- Has inspired similar languages (StevenSeagalC, etc.)
- Some companies have used it for team building

## Arnold Quotes Used

Sample of memorable quotes used as keywords:
- "I'll be back" - Return statement
- "Hasta la vista, baby" - End program
- "Consider that a divorce" - Variable destruction
- "Knock knock" - Function call
- "Listen to me very carefully" - Function definition

## Community

- Active GitHub community
- Regular updates and maintenance
- Educational workshops
- Entertainment programming competitions

---

**Difficulty**: 🟡🟡⚪⚪⚪ Moderate (need to remember quotes)
**Practical Use**: Educational/Entertainment
**Turing Complete**: ✅ Yes
**Coolness Factor**: 💪 MAXIMUM
**One-liners**: 🎬 100%


*Last updated: 2025-11-19*
