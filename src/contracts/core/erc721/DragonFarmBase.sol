// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./DragonAccessControl.sol";
abstract contract DragonFarmBase is ERC721, DragonAccessControl {

    struct Dragon {
        uint256 genes;
        uint256 bornAt;
    }

    Dragon[] dragons;
        
    mapping(address => uint[]) listNftsOf;
    
    function totalSupply() public view returns (uint256) {
        return dragons.length;
    }
    
    function getNftsOf(address _owner) external view returns(uint[] memory) {
        return listNftsOf[_owner];
    }

    function _spawnDragon(uint256 _genes, address _owner)
        internal
        returns (uint256)
    {
        Dragon memory _dragon = Dragon(_genes, block.timestamp);
        dragons.push(_dragon);
        uint256 _dragonId = totalSupply() - 1;
        _mint(_owner, _dragonId);
        listNftsOf[_owner].push(_dragonId);
        return _dragonId;
    }
}
