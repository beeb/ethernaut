// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { IDetectionBot, IForta, CryptoVault } from "src/Level26.sol";

contract L26Bot is IDetectionBot {
    IForta forta;
    CryptoVault vault;
    address owner;

    constructor(address _owner, IForta _forta, CryptoVault _vault) {
        forta = _forta;
        vault = _vault;
        owner = _owner;
    }

    function handleTransaction(address user, bytes calldata msgData) external {
        require(user == owner, "only player");
        require(msg.sender == address(forta), "only forta");
        (,, address origSender) = abi.decode(msgData[4:], (address, uint256, address));
        if (origSender == address(vault)) {
            forta.raiseAlert(user);
        }
    }
}
