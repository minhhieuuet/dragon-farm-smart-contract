// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./DragonFarmBase.sol";
contract DragonFarmCore is DragonFarmBase {
    address contractAddress;
    constructor(address marketplaceAddress) ERC721("DragonFarmNFT", "DFNFT") {
        contractAddress = marketplaceAddress;
    }


    function spawnDragon(uint256 _genes, address _owner, uint32 matronId, uint32 sireId)
        external
        onlyCLevel
        returns (uint256)
    {
        uint256 dragonId = _spawnDragon(_genes, _owner, matronId, sireId);
        setApprovalForAll(contractAddress, true);
        return dragonId;
    }

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
    //

}
