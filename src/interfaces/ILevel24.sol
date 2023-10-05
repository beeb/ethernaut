// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface PuzzleProxy {
    function pendingAdmin() external returns (address);

    function admin() external returns (address);

    function proposeNewAdmin(address _newAdmin) external;

    function approveNewAdmin(address _expectedAdmin) external;

    function upgradeTo(address _newImplementation) external;
}

interface PuzzleWallet {
    function owner() external returns (address);

    function maxBalance() external returns (uint256);

    function whitelisted(address addr) external returns (bool);

    function balances(address addr) external returns (uint256);

    function setMaxBalance(uint256 _maxBalance) external;

    function addToWhitelist(address addr) external;

    function deposit() external payable;

    function execute(address payable _to, uint256 _value, bytes calldata _data) external payable;

    function multicall(bytes[] calldata data) external payable;
}
