# Contributing to EchoScroll

Thank you for your interest in contributing to EchoScroll! We welcome contributions from developers of all skill levels.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)

## Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Getting Started

1. **Fork the repository**
   ```bash
   git clone https://github.com/pavlenkotm/EchoScroll.git
   cd EchoScroll
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

## How to Contribute

### Reporting Bugs

- Use GitHub Issues
- Include detailed description
- Provide reproduction steps
- Include error messages and logs
- Specify your environment (OS, Node version, etc.)

### Suggesting Enhancements

- Use GitHub Issues with "enhancement" label
- Explain the use case
- Provide examples
- Consider implementation details

### Adding New Language Examples

We welcome new programming language examples! To add a new language:

1. Create a new directory under `examples/[language-name]/`
2. Include a working example with:
   - Runnable code
   - README.md with setup instructions
   - Tests (if applicable)
   - Package/build configuration
3. Update the main README.md to include your example
4. Submit a pull request

#### Example Structure

```
examples/your-language/
├── README.md          # Setup and usage
├── src/               # Source code
├── tests/             # Test files
├── package.json       # Dependencies (if applicable)
└── .gitignore         # Language-specific ignores
```

## Development Workflow

### 1. Setup Development Environment

```bash
# Install all dependencies
npm install

# Setup environment variables
cp .env.example .env
```

### 2. Make Changes

- Write clean, readable code
- Follow existing code style
- Add comments where necessary
- Update documentation

### 3. Test Your Changes

```bash
# Run all tests
npm test

# Test specific language
cd examples/[language]
# Run language-specific tests
```

### 4. Commit Your Changes

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(scope): add new feature
fix(scope): fix bug
docs(scope): update documentation
test(scope): add tests
chore(scope): update dependencies
refactor(scope): refactor code
```

Examples:
```bash
git commit -m "feat(rust): add Solana staking example"
git commit -m "fix(python): correct web3.py version"
git commit -m "docs(readme): update installation steps"
```

## Coding Standards

### General Guidelines

- Write self-documenting code
- Add comments for complex logic
- Follow DRY (Don't Repeat Yourself)
- Keep functions small and focused
- Use meaningful variable names

### Language-Specific Standards

#### Solidity

- Follow [Solidity Style Guide](https://docs.soliditylang.org/en/latest/style-guide.html)
- Use NatSpec comments
- Include events for state changes
- Add access control modifiers
- Optimize for gas efficiency

```solidity
/// @notice Transfer tokens to recipient
/// @param recipient Address to receive tokens
/// @param amount Number of tokens to transfer
/// @return success True if transfer succeeded
function transfer(address recipient, uint256 amount)
    public
    returns (bool success)
{
    // Implementation
}
```

#### TypeScript/JavaScript

- Use ESLint configuration
- Follow Airbnb style guide
- Use TypeScript strict mode
- Document public APIs with JSDoc

```typescript
/**
 * Deploys a smart contract
 * @param contractName - Name of the contract to deploy
 * @param args - Constructor arguments
 * @returns Deployed contract address
 */
async function deployContract(
    contractName: string,
    ...args: any[]
): Promise<string> {
    // Implementation
}
```

#### Python

- Follow PEP 8
- Use type hints
- Document with docstrings
- Use Black formatter

```python
def get_balance(address: str) -> Decimal:
    """
    Get ETH balance for an address.

    Args:
        address: Ethereum address to query

    Returns:
        Balance in ETH

    Raises:
        ValueError: If address is invalid
    """
    # Implementation
```

#### Rust

- Follow Rust style guide
- Use cargo fmt
- Add doc comments
- Handle errors with Result

```rust
/// Calculate transaction hash
///
/// # Arguments
///
/// * `data` - Transaction data bytes
///
/// # Returns
///
/// 32-byte hash of the transaction
pub fn hash_transaction(data: &[u8]) -> [u8; 32] {
    // Implementation
}
```

## Testing

### Test Requirements

- All new features must include tests
- Maintain or improve code coverage
- Tests should be clear and well-documented
- Use descriptive test names

### Running Tests

```bash
# Solidity
npx hardhat test

# Python
cd examples/python/[example]
pytest

# Rust
cd examples/rust/[example]
cargo test

# Go
cd examples/go/[example]
go test
```

### Writing Tests

Example Solidity test:

```javascript
describe("EchoScroll", function () {
    it("Should publish a scroll", async function () {
        const [owner] = await ethers.getSigners();
        const scroll = await EchoScroll.deploy();

        await scroll.publishScroll(
            "ipfsHash",
            "spellHash",
            "Test Title"
        );

        const scrollData = await scroll.getScroll(0);
        expect(scrollData.title).to.equal("Test Title");
    });
});
```

## Pull Request Process

1. **Update Documentation**
   - Update README.md if adding features
   - Add/update code comments
   - Update relevant documentation

2. **Ensure Tests Pass**
   - All tests must pass
   - Add tests for new features
   - Maintain code coverage

3. **Follow Commit Conventions**
   - Use conventional commits
   - Keep commits atomic
   - Write clear commit messages

4. **Create Pull Request**
   - Use clear PR title
   - Describe changes in detail
   - Link related issues
   - Add screenshots if UI changes

5. **Code Review**
   - Address reviewer feedback
   - Keep PR updated with main branch
   - Squash commits if requested

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests pass locally
- [ ] Added new tests
- [ ] Updated existing tests

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed code
- [ ] Commented complex code
- [ ] Updated documentation
- [ ] No new warnings
- [ ] Added tests
- [ ] Tests pass
```

## Additional Guidelines

### Security

- Never commit private keys or secrets
- Use environment variables for sensitive data
- Follow security best practices
- Report security vulnerabilities privately

### Documentation

- Update README for new features
- Add inline code comments
- Include usage examples
- Document breaking changes

### Performance

- Consider gas optimization for Solidity
- Profile code for bottlenecks
- Optimize hot paths
- Document performance considerations

## Getting Help

- **Discord**: [Join our Discord](#)
- **GitHub Discussions**: Ask questions
- **GitHub Issues**: Report bugs
- **Twitter**: [@your_twitter](#)

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Project documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to EchoScroll! 🙏
