pragma solidity ^0.5.0;

contract CrossChainWallet {
    address public owner;
    mapping (address => uint) public balances;

    constructor() public {
        owner = msg.sender;
    }

    function deposit(address token, uint amount) public {
        // Ensure the message is coming from the correct chain
        require(msg.sender == token, "Incorrect chain");

        // Update the balance of the depositor
        balances[msg.sender] += amount;
    }

    function withdraw(address token, uint amount) public {
        // Ensure the message is coming from the correct chain
        require(msg.sender == token, "Incorrect chain");

        // Check if the depositor has sufficient balance
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // Transfer the funds to the recipient on the other chain
        (bool success, ) = token.transfer(msg.sender, amount);

        // Update the balance of the depositor
        balances[msg.sender] -= amount;

        // If the transfer failed, revert the transaction
        require(success, "Transfer failed");
    }

    function getBalance(address account) public view returns (uint) {
        return balances[account];
    }

    function transfer(address recipient, uint amount) public {
        // Check if the sender has sufficient balance
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // Transfer the funds to the recipient
        balances[recipient] += amount;
        balances[msg.sender] -= amount;
    }
}
