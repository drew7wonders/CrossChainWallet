pragma solidity ^0.8.0;

contract CrossChainWallet {
    // The address of the Ethereum chain
    address public ethereumChainAddress;
    // The address of the Polygon chain
    address public polygonChainAddress;
    // The address of the Moonbeam chain
    address public moonbeamChainAddress;

    // The mapping of user addresses to their respective balances
    mapping(address => uint256) public userBalances;

    // The constructor sets the addresses of the different chains
    constructor(address _ethereumChainAddress, address _polygonChainAddress, address _moonbeamChainAddress) public {
        ethereumChainAddress = _ethereumChainAddress;
        polygonChainAddress = _polygonChainAddress;
        moonbeamChainAddress = _moonbeamChainAddress;
    }

    // This function allows a user to transfer funds from their wallet on one chain to another
    function transferFunds(address _fromChain, address _toChain, address _to, uint256 _amount) public {
        require(_fromChain == ethereumChainAddress || _fromChain == polygonChainAddress || _fromChain == moonbeamChainAddress, "Invalid from chain address.");
        require(_toChain == ethereumChainAddress || _toChain == polygonChainAddress || _toChain == moonbeamChainAddress, "Invalid to chain address.");

        // Check that the user has sufficient funds in their wallet
        require(userBalances[_fromChain] >= _amount, "Insufficient funds in wallet.");

        // Send a general message to the destination chain with the transfer information
        (_toChain).call(abi.encodeWithSignature("transfer(address,uint256)", _to, _amount));

        // Update the user's balance on the source chain
        userBalances[_fromChain] -= _amount;
    }

    // This function is called by the destination chain to receive the transferred funds
    function transfer(address _to, uint256 _amount) public {
        // Update the user's balance on the destination chain
        userBalances[msg.sender] += _amount;
    }
}
