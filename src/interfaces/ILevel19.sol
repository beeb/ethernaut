// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface AlienCodex {
    error OwnableUnauthorizedAccount(address account);
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function owner() external view returns (address);

    function contact() external returns (bool);

    function codex(uint256 i) external returns (bytes32);

    function makeContact() external;

    function record(bytes32 _content) external;

    function retract() external;

    function revise(uint256 i, bytes32 _content) external;
}
