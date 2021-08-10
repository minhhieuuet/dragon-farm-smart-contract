// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DragonSoul is ERC20, Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    uint256 public maxSupply = 100 * 10**6 * 10**18;
    uint256 public amountPlayToEarn = 28 * 10**6 * 10**18;
    uint256 internal amountFarm = 15 * 10**6 * 10**18;
    uint256 public tokenForManger = 2 * 10**5 * 10**18;
    
    constructor() ERC20("Dragon Soul", "DRAS")
    {
        _mint(_msgSender(), maxSupply.sub(amountFarm).sub(amountPlayToEarn));
    }

    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }
    
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        uint256 transferFeeRate = sender == owner() ? 0 : 5;
        if (
            transferFeeRate > 0 &&
            sender != address(this) &&
            recipient != address(this)
        ) {
            uint256 _fee = amount.mul(transferFeeRate).div(100);
            super._transfer(sender, address(this), _fee); // TransferFee
            amount = amount.sub(_fee);
        }

        super._transfer(sender, recipient, amount);
    }
    
     function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _transferOwnership(address newOwner) public onlyOwner {
        transferOwnership(newOwner);
    }
}