//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract MyToken is IERC20 {
    address public tokenOwner = msg.sender;
    uint public totalSup;
    string public name = "My Token";
    string public symbol = "MTK";
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowances;

    modifier onlyOwner {
        require(msg.sender == tokenOwner);
        _;
    }

    function totalSupply() external override view returns (uint) {
        
        return totalSup;
    }


    function balanceOf(address account) override external view returns (uint) {

        return balances[account];
    }

    function transfer(address recipient, uint amount) override external returns (bool) {
        require(balances[msg.sender] >= amount, "No Sufficient amount");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);

        return true;
    }

    function allowance(address owner, address spender) override external view returns (uint) {

    }

    function approve(address spender, uint amount) override external returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) override external returns (bool) {
        require(allowances[sender][msg.sender] >= amount, "Not allowed");
        allowances[sender][msg.sender] -=amount;
        balances[sender] -=amount;
        balances[recipient] +=amount;
        emit Transfer(sender, recipient, amount);  

        return true;      
    }


    function mint(uint _amount) external onlyOwner returns (bool) {
        totalSup +=_amount;
        balances[msg.sender] += _amount;
        emit Transfer(address(0), msg.sender, _amount);

        return true;
    }
    
    function burn(uint _amount) external onlyOwner returns(bool) {
        totalSup -= _amount;
        balances[msg.sender] -= _amount;
        emit Transfer(msg.sender, address(0), _amount);

        return true;
    }

}