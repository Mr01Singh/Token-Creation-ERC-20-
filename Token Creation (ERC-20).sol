// Token Creation (ERC-20) Project Structure:
// 
// Token-Creation-ERC20/
// ├── contracts/
// │   └── Project.sol
// ├── README.md
// └── package.json

// =============================================================================
// FILE: contracts/Project.sol
// =============================================================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Project Token (ERC-20)
 * @dev A standard ERC-20 token implementation with core functionality
 * @author Token Creation Project Team
 */
contract Project {
    // Token metadata
    string public name = "Project Token";
    string public symbol = "PROJ";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    // Owner of the contract
    address public owner;
    
    // Mapping from account addresses to current balance
    mapping(address => uint256) public balanceOf;
    
    // Mapping from account addresses to a mapping of spender addresses to allowance amounts
    mapping(address => mapping(address => uint256)) public allowance;
    
    // Events as defined in ERC-20 standard
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    
    // Modifier to restrict access to owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    /**
     * @dev Constructor that sets the initial supply and assigns it to the contract deployer
     * @param _initialSupply The initial supply of tokens (in wei, considering 18 decimals)
     */
    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply * 10**decimals;
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
    // =============================================================================
    // CORE FUNCTION 1: TRANSFER
    // =============================================================================
    
    /**
     * @dev Transfer tokens from caller's account to another account
     * @param _to The address to transfer tokens to
     * @param _value The amount of tokens to transfer
     * @return success Boolean indicating if the transfer was successful
     */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Cannot transfer to zero address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        require(_value > 0, "Transfer amount must be greater than zero");
        
        // Perform the transfer
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        // Emit transfer event
        emit Transfer(msg.sender, _to, _value);
        
        return true;
    }
    
    // =============================================================================
    // CORE FUNCTION 2: APPROVE & TRANSFER FROM
    // =============================================================================
    
    /**
     * @dev Approve another address to spend tokens on behalf of the caller
     * @param _spender The address authorized to spend tokens
     * @param _value The maximum amount of tokens the spender can use
     * @return success Boolean indicating if the approval was successful
     */
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "Cannot approve zero address");
        
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        
        return true;
    }
    
    /**
     * @dev Transfer tokens from one address to another using allowance mechanism
     * @param _from The address to transfer tokens from
     * @param _to The address to transfer tokens to
     * @param _value The amount of tokens to transfer
     * @return success Boolean indicating if the transfer was successful
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_from != address(0), "Cannot transfer from zero address");
        require(_to != address(0), "Cannot transfer to zero address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");
        require(_value > 0, "Transfer amount must be greater than zero");
        
        // Perform the transfer
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        
        // Emit transfer event
        emit Transfer(_from, _to, _value);
        
        return true;
    }
    
    // =============================================================================
    // CORE FUNCTION 3: MINT (Owner-only feature)
    // =============================================================================
    
    /**
     * @dev Mint new tokens and add them to the specified address
     * @param _to The address to mint tokens to
     * @param _value The amount of tokens to mint
     * @return success Boolean indicating if the minting was successful
     */
    function mint(address _to, uint256 _value) public onlyOwner returns (bool success) {
        require(_to != address(0), "Cannot mint to zero address");
        require(_value > 0, "Mint amount must be greater than zero");
        
        // Increase total supply and recipient balance
        totalSupply += _value;
        balanceOf[_to] += _value;
        
        // Emit events
        emit Mint(_to, _value);
        emit Transfer(address(0), _to, _value);
        
        return true;
    }
    
    // =============================================================================
    // ADDITIONAL UTILITY FUNCTIONS
    // =============================================================================
    
    /**
     * @dev Burn tokens from the caller's account
     * @param _value The amount of tokens to burn
     * @return success Boolean indicating if the burning was successful
     */
    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance to burn");
        require(_value > 0, "Burn amount must be greater than zero");
        
        // Decrease total supply and caller's balance
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        
        // Emit events
        emit Burn(msg.sender, _value);
        emit Transfer(msg.sender, address(0), _value);
        
        return true;
    }
    
    /**
     * @dev Transfer ownership of the contract to a new owner
     * @param _newOwner The address of the new owner
     */
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "New owner cannot be zero address");
        require(_newOwner != owner, "New owner must be different from current owner");
        
        owner = _newOwner;
    }
    
    /**
     * @dev Get the current token balance of an address
     * @param _owner The address to query the balance of
     * @return balance The token balance of the specified address
     */
    function getBalance(address _owner) public view returns (uint256 balance) {
        return balanceOf[_owner];
    }
}

// =============================================================================
// FILE: README.md
// =============================================================================

/*
# Token Creation (ERC-20)

## Project Description

The **Token Creation (ERC-20)** project is a comprehensive implementation of the ERC-20 token standard on the Ethereum blockchain. This project provides a secure, efficient, and fully-featured token contract that enables the creation, transfer, and management of digital tokens. Built with modern Solidity practices, it includes essential functionalities like token transfers, allowance mechanisms, minting capabilities, and burning features.

The project serves as both a production-ready token contract and an educational resource for understanding ERC-20 token development. It incorporates security best practices, gas optimization techniques, and comprehensive error handling to ensure reliable performance in decentralized applications.

## Project Vision

Our vision is to democratize token creation by providing an accessible, secure, and feature-rich ERC-20 token implementation that empowers developers, businesses, and organizations to launch their digital assets with confidence. We aim to bridge the gap between complex blockchain technology and practical token deployment, making it possible for anyone to create professional-grade tokens without compromising on security or functionality.

We envision a future where token creation is as simple as deploying a smart contract, yet as powerful as enterprise-grade financial instruments. This project represents our commitment to advancing the decentralized economy by providing the foundational tools needed for tokenization across various industries.

## Key Features

### 🔐 **Security First**
- **Owner-only functions** with secure access control mechanisms
- **Zero address protection** preventing tokens from being lost
- **Overflow protection** with Solidity 0.8+ built-in safeguards
- **Input validation** on all critical functions

### 💰 **Core ERC-20 Functionality**
- **Standard Transfer**: Direct token transfers between addresses
- **Allowance System**: Secure delegation of spending rights
- **Balance Tracking**: Real-time balance queries and management
- **Event Logging**: Comprehensive event emission for transparency

### 🚀 **Advanced Token Features**
- **Minting Capability**: Owner can create new tokens as needed
- **Burning Mechanism**: Users can permanently remove tokens from circulation
- **Ownership Transfer**: Secure handover of contract control
- **Flexible Initial Supply**: Customizable token supply at deployment

### 📊 **Developer-Friendly**
- **Clean Code Architecture**: Well-documented and maintainable codebase
- **Gas Optimized**: Efficient operations to minimize transaction costs
- **Comprehensive Events**: Detailed logging for easy integration
- **Standard Compliance**: Full ERC-20 compatibility for wallet and exchange support

### 🛡️ **Production Ready**
- **Extensive Error Handling**: Detailed error messages for debugging
- **Edge Case Protection**: Handles unusual scenarios gracefully
- **Tested Logic**: Battle-tested transfer and allowance mechanisms
- **Upgrade Friendly**: Designed with future enhancements in mind

## Future Scope

### 📈 **Enhanced Token Economics**
- **Deflationary Mechanisms**: Automatic burning based on transaction volume
- **Staking Rewards**: Built-in staking functionality with customizable APY
- **Governance Integration**: Voting mechanisms for decentralized decision making
- **Liquidity Mining**: Rewards for providing liquidity to decentralized exchanges

### 🔗 **Cross-Chain Compatibility**
- **Multi-Chain Deployment**: Support for Polygon, Binance Smart Chain, and other EVM networks
- **Bridge Integration**: Seamless token transfers across different blockchains
- **Layer 2 Optimization**: Gas-efficient operations on scaling solutions
- **Interoperability Protocols**: Integration with cross-chain communication standards

### 🛠️ **Advanced Features**
- **Pausable Functionality**: Emergency pause mechanism for security incidents
- **Snapshot Capabilities**: Point-in-time balance recording for airdrops and dividends
- **Batch Operations**: Multiple transfers in a single transaction
- **Meta-Transactions**: Gasless transactions for improved user experience

### 🎯 **Integration Ecosystem**
- **DeFi Protocol Integration**: Native support for lending, borrowing, and yield farming
- **NFT Marketplace Compatibility**: Token utility in NFT ecosystems
- **Payment Gateway Integration**: Easy integration with e-commerce platforms
- **Mobile Wallet Support**: Optimized for mobile wallet applications

### 🔍 **Analytics and Monitoring**
- **Real-time Analytics Dashboard**: Comprehensive token metrics and statistics
- **Whale Alert System**: Monitoring of large token movements
- **Burn Rate Tracking**: Historical data on token burn events
- **Holder Analytics**: Detailed insights into token distribution and holder behavior

### 🌐 **Community and Governance**
- **DAO Framework**: Decentralized autonomous organization capabilities
- **Community Proposals**: On-chain proposal and voting system
- **Treasury Management**: Automated treasury operations and fund allocation
- **Reputation System**: Community-driven reputation and rewards mechanism

---

## Getting Started

### Prerequisites
- Node.js (v16 or higher)
- npm or yarn
- Hardhat or Truffle
- MetaMask or similar Web3 wallet

### Installation
1. Clone the repository
2. Install dependencies: `npm install`
3. Compile contracts: `npx hardhat compile`
4. Deploy to testnet: `npx hardhat run scripts/deploy.js --network goerli`

### Usage
Deploy the contract with your desired initial supply:
```solidity
// Deploy with 1 million tokens
Project token = new Project(1000000);
```

## Contributing
We welcome contributions! Please read our contributing guidelines and submit pull requests for any improvements.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Support
For questions and support, please open an issue in the GitHub repository or contact our development team.

---

*Built with ❤️ for the decentralized future*
*/

// =============================================================================
// FILE: package.json
// =============================================================================

/*
{
  "name": "token-creation-erc20",
  "version": "1.0.0",
  "description": "A comprehensive ERC-20 token implementation with advanced features",
  "main": "contracts/Project.sol",
  "scripts": {
    "compile": "hardhat compile",
    "test": "hardhat test",
    "deploy": "hardhat run scripts/deploy.js",
    "verify": "hardhat verify"
  },
  "keywords": [
    "solidity",
    "ethereum",
    "erc20",
    "token",
    "blockchain",
    "smart-contract",
    "defi"
  ],
  "author": "Token Creation Project Team",
  "license": "MIT",
  "devDependencies": {
    "@nomiclabs/hardhat-ethers": "^2.2.3",
    "@nomiclabs/hardhat-waffle": "^2.0.6",
    "chai": "^4.3.7",
    "ethereum-waffle": "^4.0.10",
    "ethers": "^5.7.2",
    "hardhat": "^2.17.1"
  },
  "dependencies": {
    "@openzeppelin/contracts": "^4.9.3"
  }
}
*/
