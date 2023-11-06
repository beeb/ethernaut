// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { Forta, CryptoVault, DoubleEntryPoint } from "src/Level26.sol";
import { L26Bot } from "src/Level26Bot.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x34bD06F195756635a10A7018568E033bC15F3FB5);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[4].topics[2])));
        console2.log(instanceAddress);

        (,, address txOrigin) = vm.readCallers();
        DoubleEntryPoint dep = DoubleEntryPoint(instanceAddress);
        Forta forta = Forta(dep.forta());
        CryptoVault vault = CryptoVault(dep.cryptoVault());
        L26Bot bot = new L26Bot(txOrigin, forta, vault);
        forta.setDetectionBot(address(bot));

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
