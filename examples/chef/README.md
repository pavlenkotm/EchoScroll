# Chef - Programming Language as Cooking Recipes

## Overview

**Chef** is an esoteric programming language created by David Morgan-Mar in 2002. Programs are written in the format of cooking recipes, making it one of the most creative and humorous programming languages. The goal was to create programs that are not only executable but also read like actual recipes.

## Language Features

- **Recipe Format**: Programs look like real cooking recipes
- **Stack-based**: Uses mixing bowls as stacks
- **Ingredient Values**: ASCII values of characters
- **Measurement Units**: g, kg, ml, etc. represent numbers
- **Turing Complete**: Can compute anything computable
- **Readable**: Can be read as legitimate recipes

### Recipe Structure

```
[Recipe Title]

[Descriptive comment]

Ingredients.
[Ingredient list with amounts]

Method.
[Cooking instructions]

Serves [number].
```

## Key Concepts

### Ingredients
Ingredients represent variables. Their initial values are:
- **Dry ingredients** (g, kg, pinch): Initial value from measurement
- **Liquid ingredients** (ml, l, dash): Initial value from measurement
- **"Heaped"** or **"level"**: Modifiers for values

Examples:
```chef
72 g haricot beans     # Value: 72 (ASCII 'H')
101 eggs               # Value: 101 (ASCII 'e')
```

### Kitchen Equipment

| Equipment | Programming Concept |
|-----------|-------------------|
| Mixing bowl | Stack |
| Baking dish | Output buffer |
| Refrigerator | Input source |

### Commands

| Chef Command | Programming Action |
|--------------|-------------------|
| `Put [ingredient] into [bowl]` | Push onto stack |
| `Fold [ingredient] into [bowl]` | Pop from stack |
| `Add [ingredient]` | Addition |
| `Remove [ingredient]` | Subtraction |
| `Combine [ingredient]` | Multiplication |
| `Divide [ingredient]` | Division |
| `Liquefy [ingredient]` | Convert to character |
| `Liquefy contents of [bowl]` | Convert all to characters |
| `Pour contents into [dish]` | Output |
| `Stir [bowl] for [number] minutes` | Rotate stack |
| `Mix well` | Shuffle stack |
| `Clean [bowl]` | Clear stack |
| `Serve with [recipe]` | Function call |
| `Refrigerate for [number] hours` | Loop |

## Examples in This Directory

### 1. **Hello World Souffle** (`hello_world.chef`)
Classic greeting as a gourmet recipe.

**Explanation**:
- Each ingredient represents an ASCII character
- 72g = 'H', 101 eggs = 'e', 108g = 'l', etc.
- Ingredients are put into mixing bowl (stack)
- Liquefied to convert numbers to characters
- Poured into baking dish (output)

### 2. **Fibonacci Numbers with Caramel Sauce** (`fibonacci.chef`)
Calculates Fibonacci sequence.

**Features**:
- Initial values (0, 1)
- Loop control
- Arithmetic operations
- Output formatting

### 3. **Blockchain Counter Cake** (`blockchain_counter.chef`)
Simulates blockchain block counting.

**Features**:
- Genesis block initialization
- Block increment
- Target block limit
- Sequential processing

## Running Chef Programs

### Online Interpreters
- [progopedia.com/dialect/chef](http://www.progopedia.com/dialect/chef)
- [repl.it Chef](https://repl.it/languages/chef)

### Local Installation

#### Python Implementation (pychef)
```bash
pip install pychef
pychef hello_world.chef
```

#### Ruby Implementation
```bash
gem install chef-lang
chef-lang hello_world.chef
```

#### Perl Implementation (Original)
```bash
# Download from http://www.dangermouse.net/esoteric/chef.html
perl chef.pl hello_world.chef
```

## Language Constructs

### Basic Output

```chef
Output Hello.

Ingredients.
72 g letter H

Method.
Put letter H into mixing bowl.
Liquefy contents of the mixing bowl.
Pour contents of the mixing bowl into the baking dish.

Serves 1.
```

### Arithmetic

```chef
Addition Recipe.

Ingredients.
5 g first number
3 g second number

Method.
Put first number into mixing bowl.
Add second number.
Fold result into mixing bowl.
Liquefy contents of the mixing bowl.
Pour contents of the mixing bowl into the baking dish.

Serves 1.
```

### Loops

```chef
Counting Recipe.

Ingredients.
10 g counter

Method.
Put counter into mixing bowl.
Verb the counter until verbed.
Remove counter.
Put counter into mixing bowl.
Liquefy contents of the mixing bowl.
Pour contents of the mixing bowl into the baking dish.

Serves 1.
```

## Advanced Example: Sum of Numbers

```chef
Number Addition Casserole.

This recipe adds numbers together, much like combining ingredients to create
a perfect dish. Each ingredient contributes to the final sum.

Ingredients.
5 g first ingredient
10 g second ingredient
15 g third ingredient
0 g mixing bowl

Method.
Put first ingredient into mixing bowl.
Add second ingredient to mixing bowl.
Add third ingredient to mixing bowl.
Fold result into mixing bowl.
Liquefy contents of the mixing bowl.
Pour contents of the mixing bowl into the baking dish.

Serves 1.
```

## Web3 Connection

Chef recipes demonstrate blockchain concepts:

1. **Sequential Processing**: Like transaction ordering
2. **State Management**: Mixing bowls as state containers
3. **Deterministic**: Same ingredients = same result
4. **Layered Architecture**: Stack-based like blockchain layers

## Project Context

Part of **EchoScroll's** esoteric language collection. Chef demonstrates:
- Programming can be expressed through any domain language
- Code can be both functional and artistic
- Creative constraints inspire innovation
- Documentation matters (recipes are self-documenting!)

## Tips for Writing Chef

1. **Think in ASCII**: Convert characters to numbers
2. **Plan Your Stacks**: Know your mixing bowl state
3. **Use Descriptive Names**: Make it sound like real cooking
4. **Test Incrementally**: Build the recipe step by step
5. **Liquefying**: Remember to liquefy before output

## Recipe Validation

A valid Chef program should:
- Read like a plausible recipe
- Have reasonable ingredient amounts
- Use appropriate cooking terminology
- Include method steps that make culinary sense
- Specify serving size

## Resources

- [Chef Language Spec](https://esolangs.org/wiki/Chef)
- [DangerMouse Chef](http://www.dangermouse.net/esoteric/chef.html)
- [Chef Examples](https://github.com/search?q=chef+language+examples)
- [Esolang Chef](https://esolangs.org/wiki/Chef)

## Fun Facts

- Created by David Morgan-Mar (also creator of Piet)
- Programs have been published in cookbooks
- Some recipes are actually cookable (with substitutions)
- Used in programming language courses as an example
- Has inspired other "natural language" esolangs

## Example Recipes That Work

Some Chef programs that are close to real recipes:
- "Hello World Souffle" - makes a lot of souffle
- "Fibonacci Numbers with Caramel Sauce" - sweet and mathematical
- "Quine with Chocolate Chips" - self-replicating dessert

## Culinary Programming Tips

### Ingredient Selection
- Use common cooking ingredients
- Match amounts to ASCII values naturally
- Choose ingredients that fit the dish theme

### Method Writing
- Use standard cooking verbs
- Maintain recipe flow
- Keep it believable

### Serving Suggestions
- Always include "Serves X"
- Think about actual portions
- Consider the theme

## Community

- Active esolang community
- Featured in cooking blogs
- Used in CS education
- Art and code intersection enthusiasts

---

**Difficulty**: 🟡🟡🟡⚪⚪ Moderate
**Practical Use**: Educational/Artistic
**Turing Complete**: ✅ Yes
**Deliciousness**: 🍰 Maximum
**Code as Art**: 🎨 Absolutely
**Would You Eat It?**: 🤔 Maybe?
