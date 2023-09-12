// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract L18Attack {
    function deploy() external returns (address) {
        // Init code
        // 60 0a - push 10 onto stack (length of runtime code)
        // 60 0c - push 12 onto stack (position of runtime code in tx data)
        // 60 00 - push 0 onto stack (location in memory)
        // 39 - codecopy
        // 60 0a - push 10 onto stack (length of return value = runtime code length)
        // 60 00 - push 0 onto stack (location of runtime code in memory)
        // f3 - return
        bytes memory initCode = hex"600a600c600039600a6000f3";
        // Runtime code
        // 60 2a - push 42 onto stack
        // 60 1f - push 31 onto stack (location in memory)
        // 53 - mstore8
        // 60 20 - push 32 onto stack (lenght of return value)
        // 60 00 - push 0 onto stack (location of return value in memory)
        // f3 - return
        bytes memory runtimeCode = hex"602a601f5360206000f3";

        bytes memory code = bytes.concat(initCode, runtimeCode);

        address addr;
        assembly {
            addr := create(0, add(code, 0x20), mload(code))
        }
        require(addr != address(0), "Failed to deploy contract");
        return addr;
    }
}
