// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BalanceManager {
    struct User {
        uint256 balance;
    }

    mapping(address => User) public users;

    constructor() {
        // Initialize balances
        users[msg.sender].balance = 100;  // User1's initial balance is 100
        users[address(0x2)] = User(0);   // User2's initial balance is 0
    }

    function updateUserBalances() public {
        // Subtract 10 from User1's balance
        users[msg.sender].balance -= 10;

        // Add 10 to User2's balance
        users[address(0x2)].balance += 10;
    }
}
