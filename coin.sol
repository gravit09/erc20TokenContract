// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.1/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts@5.0.1/access/Ownable.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC20/extensions/ERC20FlashMint.sol";

contract Noble is ERC20, ERC20Burnable, ERC20Pausable, Ownable, ERC20Permit, ERC20FlashMint {
    uint256 public stakingRewardsRate = 10; 
    mapping(address => uint256) public stakingBalance;
    mapping(address => uint256) public stakingTimestamp;

    constructor(address initialOwner)
        ERC20("Noble", "NBL")
        Ownable(initialOwner)
        ERC20Permit("Noble")
    {
        _mint(msg.sender, 1000 * 10 ** decimals());
    }

    function stake(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        transfer(address(this), amount);

        stakingBalance[msg.sender] += amount;
        stakingTimestamp[msg.sender] = block.timestamp;
    }

    function unstake() public {
        require(stakingBalance[msg.sender] > 0, "No staked balance");

        uint256 stakedAmount = stakingBalance[msg.sender];
        uint256 reward = calculateReward(msg.sender);

        _transfer(address(this), msg.sender, stakedAmount + reward);

        stakingBalance[msg.sender] = 0;
        stakingTimestamp[msg.sender] = 0;
    }

    function calculateReward(address staker) public view returns (uint256) {
        uint256 timeElapsed = block.timestamp - stakingTimestamp[staker];
        return (stakingBalance[staker] * stakingRewardsRate * timeElapsed) / (365 days);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }
}
