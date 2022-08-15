//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract RolesManagment {
    mapping(bytes32=> mapping(address => bool)) public roles;

    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    // ADMIN hash: 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42

    bytes32 private constant USER = keccak256(abi.encodePacked("USER"));
    // USER hash: 0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96

    modifier onlyRole(bytes32 _role) {
        require(roles[_role][msg.sender], "Not Authorized");
        _;
    }

    event RoleSetted(bytes32 _role, address _account);
    event RoleRevoked(bytes32 _role, address _account);

    constructor() {
        callSetRole(ADMIN, msg.sender);
    }

    function callSetRole(bytes32 _role, address _account) private {
        roles[_role][_account] = true;
        emit RoleSetted(_role, _account);
    }


    function setRole(bytes32 _role, address _account) external onlyRole(ADMIN) {
        callSetRole(_role, _account);
    }

    function revokeRole(bytes32 _role, address _account) external onlyRole(ADMIN) {
        roles[_role][_account] = false;
        emit RoleRevoked(_role, _account);
    }

}