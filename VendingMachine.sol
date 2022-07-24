// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract VendingMachine {
    address public owner;
    mapping(address => uint) public cackeBalances;
    // special case: each cacke costs 1ether;

    constructor() {
        owner = msg.sender;
        cackeBalances[address(this)] = 100; // this referes for the smart contract address
    }

    function getVendingMachineBalance() view public returns(uint){
        return cackeBalances[address(this)];
    }

    function addToStock() public {
        require(owner == msg.sender, "Only the owner can restock the machine!");
        cackeBalances[address(this)] +=1;
    }

    function purchaseCacke(uint amount) payable public {
        require(cackeBalances[address(this)] >=amount, "not enough cackes on the stock"); // Check the availability
        require(msg.value >= amount * 1 ether, "Insuffisant amount of ether");
        
        cackeBalances[address(this)] -=amount;
        cackeBalances[msg.sender] +=amount;
    }
}