// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../core/erc20/DragonSoul.sol";
import "../core/erc20/USDT.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DRASFarm {
    using SafeMath for uint256;
    
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public isStaking;
    mapping(address => uint256) public startTime;
    mapping(address => uint256) public dragonSoulBalance;

    string public name = "DRASFarm";

    IERC20 public tether;
    DragonSoul public dragonSoul;

    event Stake(address indexed from, uint256 amount);
    event Unstake(address indexed from, uint256 amount);
    event YieldWithdraw(address indexed to, uint256 amount);

    constructor(
        IERC20 _tether,
        DragonSoul _dragonSoul
        ) {
            tether = _tether;
            dragonSoul = _dragonSoul;
        }
    
    function daiBalance() external view returns(uint256) {
        return tether.balanceOf(msg.sender);
    }
    
    function stake(uint256 amount) public {
        require(
            amount > 0 &&
            tether.balanceOf(msg.sender) >= amount, 
            "You cannot stake zero tokens");
            
        if(isStaking[msg.sender] == true){
            uint256 toTransfer = calculateYieldTotal(msg.sender);
            dragonSoulBalance[msg.sender] += toTransfer;
        }
        
        tether.transferFrom(msg.sender, address(this), amount);
        stakingBalance[msg.sender] += amount;
        startTime[msg.sender] = block.timestamp;
        isStaking[msg.sender] = true;
        emit Stake(msg.sender, amount);
    }

    function unstake(uint256 amount) public {
        require(
            isStaking[msg.sender] = true &&
            stakingBalance[msg.sender] >= amount, 
            "Nothing to unstake"
        );
        uint256 yieldTransfer = calculateYieldTotal(msg.sender);
        startTime[msg.sender] = block.timestamp;
        uint256 balTransfer = amount;
        amount = 0;
        stakingBalance[msg.sender] -= balTransfer;
        tether.transfer(msg.sender, balTransfer);
        dragonSoulBalance[msg.sender] += yieldTransfer;
        if(stakingBalance[msg.sender] == 0){
            isStaking[msg.sender] = false;
        }
        emit Unstake(msg.sender, balTransfer);
    }

    function calculateYieldTime(address user) public view returns(uint256){
        uint256 end = block.timestamp;
        uint256 totalTime = end - startTime[user];
        return totalTime;
    }

    function calculateYieldTotal(address user) public view returns(uint256) {
        uint256 time = calculateYieldTime(user) * 10**18;
        uint256 rate = 60*60*24; // 1day - in seconds
        uint256 timeRate = SafeMath.div(time, rate);
        //Rate 0.5% perday
        uint256 rawYield = (stakingBalance[user] * timeRate * 5) / (10**18*10**3);
        return rawYield;
    } 

    function withdrawYield() public {
        uint256 toTransfer = calculateYieldTotal(msg.sender);

        require(
            toTransfer > 0 ||
            dragonSoulBalance[msg.sender] > 0,
            "Nothing to withdraw"
            );
            
        if(dragonSoulBalance[msg.sender] != 0){
            uint256 oldBalance = dragonSoulBalance[msg.sender];
            dragonSoulBalance[msg.sender] = 0;
            toTransfer += oldBalance;
        }

        startTime[msg.sender] = block.timestamp;
        dragonSoul.mint(msg.sender, toTransfer);
        emit YieldWithdraw(msg.sender, toTransfer);
    } 
}

