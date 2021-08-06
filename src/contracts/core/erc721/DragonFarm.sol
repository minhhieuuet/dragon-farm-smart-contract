// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract DragonFarmCore is ERC721{
  constructor() ERC721("DragonFarmNFT", "DFNFT") {
    dragons.push(Dragon(0, block.timestamp)); // The first dragon
    _spawnDragon(0, msg.sender);
    _spawnDragon(0, msg.sender);
    _spawnDragon(0, msg.sender);
    _spawnDragon(0, msg.sender);
    _spawnDragon(0, msg.sender);
  }

  struct Dragon {
    uint256 genes;
    uint256 bornAt;
  }

  Dragon[] dragons;
  function totalSupply() public view returns(uint) {
    return dragons.length;
  }

  function spawnDragon(uint256 _genes, address _owner) external returns(uint256) {
    return _spawnDragon(_genes, _owner);
  }
  function _spawnDragon(uint256 _genes, address _owner) private returns (uint256) {
    Dragon memory _dragon = Dragon(_genes, block.timestamp);
    dragons.push(_dragon);
    uint _dragonId = totalSupply() - 1;
    _mint(_owner, _dragonId);
    return _dragonId;
  }

}


