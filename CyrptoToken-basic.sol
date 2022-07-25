// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract BasicToken {
    address public minter;
    mapping(address => uint) public balances;

    error insufficientBalance(uint _requested, uint _available);
    event TokenTransfered(address _from, address _to, uint _amount);
    constructor() {
        minter = msg.sender;
    }

    function mint(address _receiver, uint _amount) external {
        require(msg.sender == minter, "Only the Owner of the contract can perform this action!");
        balances[_receiver] +=_amount;
    }

    function send(address _receiver, uint _amount) external {
        if(balances[msg.sender] < _amount) {
            revert insufficientBalance({
                _requested: _amount,
                _available: balances[msg.sender]
            });
        }

        balances[msg.sender] -=_amount;
        balances[_receiver] +=_amount;
        emit TokenTransfered(msg.sender, _receiver, _amount);
    }
}