pragma solidity ^0.7.0;

contract CrossChainWallet {
address public owner;
mapping(address => uint) public balances;
mapping(bytes32 => bool) public pendingTransactions;
constructor() public {
    owner = msg.sender;
}

function deposit(bytes32 _transactionId, uint _amount) public {
    require(_transactionId != 0x0, "Transaction ID cannot be empty");
    require(!pendingTransactions[_transactionId], "Transaction already exists");

    pendingTransactions[_transactionId] = true;
    emit Deposit(_transactionId, _amount);
}

function confirmDeposit(bytes32 _transactionId, uint _amount) public {
    require(pendingTransactions[_transactionId], "Transaction does not exist");
    require(_amount != 0, "Amount must be greater than 0");

    pendingTransactions[_transactionId] = false;
    balances[msg.sender] += _amount;
    emit ConfirmDeposit(_transactionId, _amount);
}

function withdraw(bytes32 _transactionId, address _to, uint _amount) public {
    require(_transactionId != 0x0, "Transaction ID cannot be empty");
    require(!pendingTransactions[_transactionId], "Transaction already exists");
    require(balances[msg.sender] >= _amount, "Insufficient balance");

    pendingTransactions[_transactionId] = true;
    balances[msg.sender] -= _amount;
    emit Withdraw(_transactionId, _to, _amount);
}

function confirmWithdraw(bytes32 _transactionId, uint _amount) public {
    require(pendingTransactions[_transactionId], "Transaction does not exist");
    require(_amount != 0, "Amount must be greater than 0");

    pendingTransactions[_transactionId] = false;
    emit ConfirmWithdraw(_transactionId, _amount);
}

event Deposit(bytes32 _transactionId, uint _amount);
event ConfirmDeposit(bytes32 _transactionId, uint _amount);
event Withdraw(bytes32 _transactionId, address _to, uint _amount);
event ConfirmWithdraw(bytes32 _transactionId, uint _amount);
}
