//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract compaignFactory {
    address[] deployedContracts;

    function createCompaign(uint _minimumContribution) external {
        Compaign newCompaign = new Compaign(_minimumContribution, msg.sender);
        deployedContracts.push(address(newCompaign));
    }

    function getAllCompaigns() external view returns(address[] memory) {
        return deployedContracts;
    }
}

contract Compaign {
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public contributors;
    uint public contributorsNum;
    Request[] public requests;

    struct Request {
        string description;
        uint amount;
        address payable recipient;
        bool complete;
        mapping(address => bool) approvals;
        uint approvalsNum;
    }

    modifier onlyManager {
        require(msg.sender == manager, "Only manager can call this action!");
        _;
    }

    constructor(uint _minimumContribution, address _manager) {
        manager = _manager;
        minimumContribution = _minimumContribution;
        contributorsNum=0;
    }

    function contribute() external payable {
        require(!contributors[msg.sender], "You are already a contributor");
        require(msg.value >= minimumContribution, "Not sufficiant money");
        contributors[msg.sender] = true;
        contributorsNum++;
    }

    function createRequest(
        string memory _description,
        uint _amount,
        address payable _recipient 
    ) external onlyManager {
        Request storage request = requests.push();
        request.description = _description;
        request.amount = _amount;
        request.recipient = _recipient;
        request.complete = false;
        request.approvalsNum =0;
    }

    function approveRequest(uint _requestIndex) external {
        Request storage request = requests[_requestIndex];
        require(contributors[msg.sender], "You need to be a contributor");
        require(!request.approvals[msg.sender], "You already approved this request");
        request.approvals[msg.sender] = true;
        request.approvalsNum++;
    }

    function finalizeRequest(uint _requestIndex) external onlyManager {
        Request storage request = requests[_requestIndex];
        require(!request.complete, "This request is already finalized");
        require(request.approvalsNum > (contributorsNum/2), "Not sufficiant approvals");
        request.recipient.transfer(request.amount);
        request.complete = true;
    }

}

 
