// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { GatekeeperTwo } from "./Level14.sol";

contract L14Attack {
    constructor(GatekeeperTwo instance) {
        // act inside constructor so that extcodesize is zero

        // Since sha3(address) ^ key must be equal to 0xfff...
        // The key must have non-zero bits where the address hash has zero bits.
        // We can get the key by xoring the address with 0xfff...
        bytes8 payload = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
        instance.enter(payload);
    }
}
