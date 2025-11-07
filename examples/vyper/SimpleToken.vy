# @version ^0.3.7
"""
@title SimpleToken
@author Web3 Multi-Language Showcase
@notice A basic ERC-20 token implementation in Vyper
@dev Demonstrates Vyper's Pythonic syntax for EVM smart contracts
"""

from vyper.interfaces import ERC20

implements: ERC20

event Transfer:
    sender: indexed(address)
    receiver: indexed(address)
    value: uint256

event Approval:
    owner: indexed(address)
    spender: indexed(address)
    value: uint256

name: public(String[32])
symbol: public(String[8])
decimals: public(uint8)
totalSupply: public(uint256)

balanceOf: public(HashMap[address, uint256])
allowance: public(HashMap[address, HashMap[address, uint256]])

@external
def __init__(_name: String[32], _symbol: String[8], _decimals: uint8, _total_supply: uint256):
    """
    @notice Initialize the token with name, symbol, decimals and total supply
    @param _name Token name
    @param _symbol Token symbol
    @param _decimals Token decimals
    @param _total_supply Initial total supply
    """
    self.name = _name
    self.symbol = _symbol
    self.decimals = _decimals
    self.totalSupply = _total_supply
    self.balanceOf[msg.sender] = _total_supply

    log Transfer(empty(address), msg.sender, _total_supply)

@external
def transfer(_to: address, _value: uint256) -> bool:
    """
    @notice Transfer tokens to a specified address
    @param _to The address to transfer to
    @param _value The amount to be transferred
    @return Success boolean
    """
    assert _to != empty(address), "Cannot transfer to zero address"
    assert self.balanceOf[msg.sender] >= _value, "Insufficient balance"

    self.balanceOf[msg.sender] -= _value
    self.balanceOf[_to] += _value

    log Transfer(msg.sender, _to, _value)
    return True

@external
def approve(_spender: address, _value: uint256) -> bool:
    """
    @notice Approve an address to spend tokens
    @param _spender The address authorized to spend
    @param _value The amount they can spend
    @return Success boolean
    """
    assert _spender != empty(address), "Cannot approve zero address"

    self.allowance[msg.sender][_spender] = _value

    log Approval(msg.sender, _spender, _value)
    return True

@external
def transferFrom(_from: address, _to: address, _value: uint256) -> bool:
    """
    @notice Transfer tokens from one address to another
    @param _from The address to transfer from
    @param _to The address to transfer to
    @param _value The amount to be transferred
    @return Success boolean
    """
    assert _to != empty(address), "Cannot transfer to zero address"
    assert self.balanceOf[_from] >= _value, "Insufficient balance"
    assert self.allowance[_from][msg.sender] >= _value, "Insufficient allowance"

    self.balanceOf[_from] -= _value
    self.balanceOf[_to] += _value
    self.allowance[_from][msg.sender] -= _value

    log Transfer(_from, _to, _value)
    return True

@external
@view
def get_balance(_account: address) -> uint256:
    """
    @notice Get the balance of an account
    @param _account The address to query
    @return The balance
    """
    return self.balanceOf[_account]
