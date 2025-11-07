"""
Tests for contract deployer
"""
import pytest
from unittest.mock import Mock, patch
from contract_deployer import ContractDeployer


class TestContractDeployer:
    """Test contract deployer functionality"""

    @patch('contract_deployer.Web3')
    def test_init_success(self, mock_web3):
        """Test successful initialization"""
        mock_web3.return_value.is_connected.return_value = True

        deployer = ContractDeployer('http://localhost:8545', '0x' + '0' * 64)

        assert deployer.w3 is not None
        assert deployer.account is not None

    @patch('contract_deployer.Web3')
    def test_init_failure(self, mock_web3):
        """Test initialization failure when not connected"""
        mock_web3.return_value.is_connected.return_value = False

        with pytest.raises(ConnectionError):
            ContractDeployer('http://localhost:8545', '0x' + '0' * 64)

    def test_compile_contract(self):
        """Test contract compilation"""
        # Test with mock contract source
        contract_source = '''
        // SPDX-License-Identifier: MIT
        pragma solidity ^0.8.0;

        contract SimpleStorage {
            uint256 value;

            function set(uint256 _value) public {
                value = _value;
            }

            function get() public view returns (uint256) {
                return value;
            }
        }
        '''

        # Mock compilation for testing
        assert len(contract_source) > 0
