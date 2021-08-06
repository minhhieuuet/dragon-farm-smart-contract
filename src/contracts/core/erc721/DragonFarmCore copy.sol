// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./DragonFarmBase.sol";
contract DragonFarmCore is ERC721, DragonFarmBase {
    constructor() ERC721("DragonFarmNFT", "DFNFT") {
    }

}
