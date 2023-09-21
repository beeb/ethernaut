// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { MagicNum } from "src/Level18.sol";
import { L18Attack } from "src/Level18Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x2132C7bc11De7A90B87375f282d36100a29f97a9);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);
        MagicNum instance = MagicNum(instanceAddress);

        L18Attack attack = new L18Attack();
        address fortyTwo = attack.deploy();
        uint256 size;
        assembly {
            size := extcodesize(fortyTwo)
        }
        console2.log(size);
        instance.setSolver(fortyTwo);
        (bool success, bytes memory value) = fortyTwo.call(abi.encodeWithSignature("whatIsTheMeaningOfLife()"));
        require(success, "call failed");
        require(uint256(bytes32(value)) == 42, "wrong answer");

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
