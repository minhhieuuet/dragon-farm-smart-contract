// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./DragonFarmBase.sol";
import "../erc20/DragonSoul.sol";
contract DragonFarmCore is DragonFarmBase {
    address marketAddress;
    address dragonSoulAddress;

    constructor(address _marketAddress) ERC721("DragonFarmNFT", "DFNFT") {
        marketAddress = _marketAddress;
    }
    
    function spawnDragon(uint256 _genes, address _owner)
        onlyCLevel
        external
        returns (uint256)
    {
        uint256 dragonId = _spawnDragon(_genes, _owner);
        setApprovalForAll(marketAddress, true);
        return dragonId;
    }
    
     function transferDragon(address _to, uint256 _tokenId) public {
        // Safety check to prevent burn Dragon
        require(_to != address(0));
        safeTransferFrom(msg.sender, _to, _tokenId);
    }
    
    // function buyDragon(uint256 _tokenId) external {
    //     DragonSoul dragonSoul = DragonSoul(payable(dragonSoulAddress));
    //     dragonSoul.approve(ownerOf(_tokenId), 1000000000000000000);
    //     // transferDragon(msg.sender, _tokenId);
    // }

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
