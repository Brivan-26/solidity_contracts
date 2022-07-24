//SPDX-Liscence:MIT
pragma solidity ^0.8.7;

contract Will {
    address owner;
    address trustedPerson; // the one who invoke payout function after owner's death.
    uint    fortune;
    bool    isDead;
    address payable[] familyAddresses; // List of inheritiances
    mapping(address => uint) inheritance;

    constructor(address _trustedPerson) payable public{
        owner = msg.sender;
        trustedPerson = _trustedPerson;
        fortune = msg.value;
        isDead = false;
    }

    modifier onlyOwner {
        require(owner == msg.sender, "Only owner of the contract can perform this action");
        _;
    }

    modifier onlyTrustedPerson {
        require(trustedPerson == msg.sender, "Only the trusted person can perform this action!");
        _;
    }
    
    modifier onlyWhenDead {
        require(isDead == true, "Can not perform this action now");
        _;
    }

    function addInheritance(address payable _person, uint _amount) external onlyOwner {
        familyAddresses.push(_person);
        inheritance[_person] = _amount;
    }

    function payout() private onlyWhenDead {
        for(uint i =0; i<familyAddresses.length; i++ ) {
            familyAddresses[i].transfer(inheritance[familyAddresses[i]]);
        }
    }

    function hasDead() external onlyTrustedPerson {
        isDead = true;
        payout();
    }

}