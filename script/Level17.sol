// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { SimpleToken } from "src/Level17.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance{ value: 0.001 ether }(0xAF98ab8F2e2B24F42C661ed023237f5B7acAB048);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);

        (,, address txOrigin) = vm.readCallers();
        address payable tokenAddress = payable(computeCreateAddress(instanceAddress, 1));
        SimpleToken token = SimpleToken(tokenAddress);
        token.destroy(payable(txOrigin));

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
