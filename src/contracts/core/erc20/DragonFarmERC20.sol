// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DragonFarmERC20 is Ownable, ERC20 {
    using SafeMath for uint256;

    uint256 public amountPlayToEarn = 28 * 10**6 * 10**18;
    uint256 internal amountFarm = 15 * 10**6 * 10**18;
    uint256 public tokenForBosses = 2 * 10**5 * 10**18;

    uint256 public playToEarnReward;
    uint256 private farmReward;
    // ManagerInterface public manager;


    address public addressForBosses;
    uint256 public sellFeeRate = 5;
    uint256 public buyFeeRate = 2;

    constructor(string memory, string memory) ERC20("Dragon Farm Token", "DFT") {
        addressForBosses = _msgSender();
    }

    function setTransferFeeRate(uint256 _sellFeeRate, uint256 _buyFeeRate)
        public
        onlyOwner
    {
        sellFeeRate = _sellFeeRate;
        buyFeeRate = _buyFeeRate;
    }
}