// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./DragonFarmBase.sol";
import "../erc20/DragonFarmToken.sol";
contract DragonFarmCore is DragonFarmBase {
    address marketAddress;
    address tokenAddress;
    

    constructor(address _marketAddress) ERC721("DragonFarmNFT", "DFNFT") {
        marketAddress = _marketAddress;
    }
    
    
    function spawnDragon(uint256 _genes, address _owner)
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
    
    function buyDragon(uint256 _tokenId) external {
        DragonFarmToken dragonFarmToken = DragonFarmToken(payable(tokenAddress));
        dragonFarmToken.approve(ownerOf(_tokenId), 1000000000000000000);
        // transferDragon(msg.sender, _tokenId);
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
    //

}
