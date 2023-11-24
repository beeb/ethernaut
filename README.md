## Ethernaut

Run `forge install` to get the standard library.

To solve a puzzle, copy the level contract in the `src` directory, or its interface in the `interfaces` directory.

Then, create a new script in the `script` directory and copy the existing examples, adjusting with the level address.

Finally, run the script with

```
forge script --rpc-url sepolia script/Levelxx.s.sol --broadcast
```

This will create the level instance, run your commands/transactions, and then finally submit the level.
To simulate the outcome, remove the `--broadcast` parameter from the command.
