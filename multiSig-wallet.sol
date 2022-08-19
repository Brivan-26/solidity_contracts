//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract MultiSigWallet {

    address[] public owners;
    uint8 public requiredVotesPerTx;
    struct Transaction {
        address to;
        uint value;
        bytes32 data;
        bool isExecuted;
        uint votesCount;
    }
    Transaction[] public transactions;

    mapping(uint => mapping(address => bool)) public hasVoted;
    mapping(address => bool) public isOwner;

    event Submit(address owner, uint amount, bytes32 data);
    event Approve(address owner, uint Tx);
    event Revoke(address owner, uint Tx);
    event Execute(address owner, uint Tx);
    event ReceivedEth(address sender, uint amount);

    receive() payable external {
        emit ReceivedEth(msg.sender, msg.value);
    } 

    modifier onlyOwner {
        require(isOwner[msg.sender], "Only the owner of the wallet can perform this action!");
        _;
    }

    modifier validTx(uint _tx) {
        require(validTx <transactions.length; "Not valid Transaction!");
        _;
    }

    modifier notExecuted(uint _tx) {
        require(!transactions[_tx].isExecuted, "Transaction already executed!");
        _;
    }

    constructor (address[] _owners, uint _requiredVotesPerTx) {
        require(_requiredVotesPerTx > 0 && _requiredVotesPerTx <= _owners.length, "Invalid number of required votes");z
        owners.push(msg.sender);
        isOwner[msg.sender] = true;
        for (uint i; i<_owners.length; i++) {
            address memory owner = _owners[i];
            require(owner !== address(0), "Invalid owner address");
            require(!isOwner[owner], "Duplicated owner!");
            owners.push(owner);
            isOwner[owner] = true;
        }
        requiredVotesPerTx = _requiredVotesPerTx;
    }

    function createTx(address _to, bytes32 memory _data) payable external onlyOwner{
        require(msg.value > 0, "Not sufficient amount of Ether!");
        transactions.push(Transaction({
            to: _to,
            value: msg.value,
            data: _data,
            isExecuted:false,
            votesCount:0
        }));
        
        emit Submit(msg.sender, msg.value, _data);
    }

    function approveTx(uint _Tx) external onlyOwner validTx(_Tx) notExecuted(_Tx) {
        require(!hasVoted[_Tx][msg.sender], "You already approved this Transaction!");
        Transaction storage transaction = transactions[_Tx];
        transaction.votesCount++;
        hasVoted[_Tx][msg.sender] = true;

        emit Approve(msg.sender, _Tx);
    }

    function revokeTx(uint _Tx) external onlyOwner validTx(_Tx) notExecuted(_Tx) {
        require(hasVoted[_Tx][msg.sender], "You didn't approve this Transaction!");
        Transaction storage transaction = transactions[_Tx];
        transaction.votesCount--;
        hasVoted[_Tx][msg.sender] = false;

        emit Revoke(msg.sender, _Tx);
    }

    function executeTx(uint _Tx) external onlyOwner validTx(_Tx) notExecuted(_Tx) {
        Transaction storage transaction = transactions[_Tx];
        require(transaction.votesCount >= requiredVotesPerTx, "Not sufficient votes");
        transaction.to.call({value: transaction.value})(transaction.data);
        transaction.isExecuted = true;

        emit Execute(msg.sender, _Tx);
    }

    function getOwners() external view returns(address[] memory) {
        return owners;
    }

    function getTransactionsNumber() external view returns(uint) {
        return transactions.length;
    }

    function getTransaction(uint _Tx) validTx(_Tx) external view 
        returns (address to, uint value, bytes32 memory data, bool isExecuted, uint confirmationsNum) {
            Transaction memory transaction = transactions[_Tx];
            return (
                transaction.to,
                transaction.value,
                transaction.data,
                transaction.isExecuted,
                transaction.votesCount
            );
        }

}