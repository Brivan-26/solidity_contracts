//SPDX-License-Identifier: MIT

// In solidity, mappings are not iterable
// This contract implements a way to iterate over a mapping
pragma solidity ^0.8.4;
contract IterableMapipng {
    mapping(address => uint) public balances;
    mapping(address => bool) public insertedKeys;
    address[] public keys;

    function set(address _key, uint _value) external {
        if(!insertedKeys[_key]) {
            balances[_key] = _value;
            insertedKeys[_key] = true;
            keys.push(_key);
        }
    }

    function getLength() view external returns (uint) {
        return keys.length;
    }

    function getFirst() view external returns (uint) {
        return balances[keys[0]];
    }

    function getLast() view external returns (uint) {
        return balances[keys[keys.length -1]];
    }

    function getAtIndex(uint _index) view external returns (uint) {
        require(_index < keys.length, "Index doesn't exist");
        return balances[keys[_index]];
    }
}