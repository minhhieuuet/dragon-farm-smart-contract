// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DragonSoul is ERC20, Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    uint256 public maxSupply = 100 * 10**6 * 10**18;
    uint256 public sellPrice;
    uint256 public buyPrice;

    constructor() ERC20("Dragon Soul", "DRS")
    {
        _mint(_msgSender(), maxSupply);
    }

     mapping (address => bool) public blackList;
     /* Internal transfer, only can be called by this contract */
    function _transfer(address _from, address _to, uint _value) internal override {
        require (_to != address(0));                               // Prevent transfer to 0x0 address. Use burn() instead
        require (balanceOf(_from) >= _value);               // Check if the sender has enough
        require (balanceOf(_to) + _value > balanceOf(_to)); // Check for overflows
        require(!blackList[_from]);                     // Check if sender is frozen
        require(!blackList[_to]);                       // Check if recipient is frozen
        transferFrom(_from, _to, _value);
    }

    function freezeAccount(address target, bool freeze) onlyOwner public {
        blackList[target] = freeze;
    }

    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
    /// @param newSellPrice Price the users can sell to the contract
    /// @param newBuyPrice Price users can buy from the contract
    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }

    /// @notice Buy tokens from contract by sending ether
    function buy() payable public {
        uint amount = msg.value / buyPrice;               // calculates the amount
        _transfer(address(this), msg.sender, amount);              // makes the transfers
    }

    /// @notice Sell `amount` tokens to contract
    /// @param amount amount of tokens to be sold
    function sell(uint256 amount) public {
        require(address(this).balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
        _transfer(msg.sender, address(this), amount);              // makes the transfers
        payable(msg.sender).transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
    }
}