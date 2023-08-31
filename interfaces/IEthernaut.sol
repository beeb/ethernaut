// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface Ethernaut {
    event LevelCompletedLog(address indexed player, address indexed instance, address indexed level);
    event LevelInstanceCreatedLog(address indexed player, address indexed instance, address indexed level);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function createLevelInstance(address _level) external payable;

    function emittedInstances(address) external view returns (address player, address level, bool completed);

    function owner() external view returns (address);

    function registerLevel(address _level) external;

    function registeredLevels(address) external view returns (bool);

    function renounceOwnership() external;

    function setStatistics(address _statProxy) external;

    function statistics() external view returns (address);

    function submitLevelInstance(address _instance) external;

    function transferOwnership(address newOwner) external;
}
