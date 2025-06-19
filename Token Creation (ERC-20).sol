// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Basic ERC-20 Token Contract
/// @author
/// @notice Implements a simple ERC-20 token with transfer, approve, and transferFrom functionality.
contract Project {
    string public name = "MyToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Events as per ERC-20 standard
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /// @notice Constructor to mint initial supply to deployer
    /// @param _initialSupply Initial token supply in whole units (not considering decimals)
    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    /// @notice Transfer tokens to a specified address
    /// @param _to Recipient address
    /// @param _value Amount to transfer (in smallest units)
    /// @return success Boolean indicating successful transfer
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "ERC20: transfer to zero address");
        require(balanceOf[msg.sender] >= _value, "ERC20: insufficient balance");

        _transfer(msg.sender, _to, _value);
        return true;
    }

    /// @notice Approve spender to transfer up to _value tokens on behalf of msg.sender
    /// @param _spender Spender address
    /// @param _value Amount allowed to spend
    /// @return success Boolean indicating approval success
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "ERC20: approve to zero address");

        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /// @notice Transfer tokens from one address to another using allowance mechanism
    /// @param _from Sender address
    /// @param _to Recipient address
    /// @param _value Amount to transfer
    /// @return success Boolean indicating transfer success
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "ERC20: transfer to zero address");
        require(balanceOf[_from] >= _value, "ERC20: insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "ERC20: allowance exceeded");

        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    /// @dev Internal transfer function
    /// @param _from Sender address
    /// @param _to Recipient address
    /// @param _value Amount to transfer
    function _transfer(address _from, address _to, uint256 _value) internal {
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }
}

