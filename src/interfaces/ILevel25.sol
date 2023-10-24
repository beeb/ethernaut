// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface Engine {
    function upgrader() external view returns (address);

    function horsePower() external view returns (uint256);

    function initialize() external;

    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}
