// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DragonFarmCore is ERC721 {
    constructor() ERC721("DragonFarmNFT", "DFNFT") {
        dragons.push(Dragon(0, block.timestamp, 0, 0)); // The first dragon
        _spawnDragon(0, msg.sender, 0, 0);
        _spawnDragon(0, msg.sender, 0, 0);
        _spawnDragon(0, msg.sender, 0, 0);
        _spawnDragon(0, msg.sender, 0, 0);
    }

    struct Dragon {
        uint256 genes;
        uint256 bornAt;
        uint32 matronId;
        uint32 sireId;
    }

    Dragon[] dragons;

    function totalSupply() public view returns (uint256) {
        return dragons.length;
    }

    function spawnDragon(uint256 _genes, address _owner, uint32 matronId, uint32 sireId)
        external
        returns (uint256)
    {
        return _spawnDragon(_genes, _owner, matronId, sireId);
    }

    function _spawnDragon(uint256 _genes, address _owner, uint32 matronId, uint32 sireId)
        private
        returns (uint256)
    {
        Dragon memory _dragon = Dragon(_genes, block.timestamp, matronId, sireId);
        dragons.push(_dragon);
        uint256 _dragonId = totalSupply() - 1;
        _mint(_owner, _dragonId);
        return _dragonId;
    }

    //Transfer dragon to another address
    function transferDragon(address _to, uint256 _tokenId) external {
        // Safety check to prevent burn Dragon
        require(_to != address(0));
        safeTransferFrom(msg.sender, _to, _tokenId);
    }

    //Approve another address the right to transfer a dragon
    function approveDragon(address _to, uint256 _tokenId) external {
        require(ownerOf(_tokenId) == msg.sender);
        approve(_to, _tokenId);
    }

    //Burn dragon

    function killDragon(uint256 _tokenId) external {
      _burn(_tokenId);
    }
}
