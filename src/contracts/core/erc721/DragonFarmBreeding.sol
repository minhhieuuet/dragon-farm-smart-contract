// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DragonFarmBreeding {
    mapping(address => uint) classGenes;
    
    
    function mixGenes() external view returns(uint) {
        uint _genes1 = 0x400000000d185222104421041085108810a4114210c4090c1062280410a508ca;
        uint _genes2 = 0x3000000004c442420c4310480c2308c20c6318c60ca318ca0cc3314a0c2308c2;
        
        // generate 256 bits of random, using as much entropy as we can from
        // sources that can't change between calls.
        uint randomN = uint256(keccak256(abi.encodePacked(block.timestamp, _genes1, _genes2)));
        uint256 randomIndex = 0;
        
        
        uint8[] memory genes1Array = decode(_genes1);
        uint8[] memory genes2Array = decode(_genes2);
        // All traits that will belong to baby
        uint8[] memory babyArray = new uint8[](48);
        
        
        
        
        return encode(genes1Array);
    }
    
    function _get5Bits(uint256 _input, uint256 _slot) internal pure returns(uint8) {
        return uint8(_sliceNumber(_input, uint256(5), _slot * 5));
    }
    
    /// @dev Given an array of traits return the number that represent genes
    function encode(uint8[] memory _traits) public pure returns (uint256 _genes) {
        _genes = 0;
        for(uint256 i = 0; i < 48; i++) {
            _genes = _genes << 5;
            // bitwise OR trait with _genes
            _genes = _genes | _traits[47 - i];
        }
        return _genes;
    }
    
    function decode(uint256 _genes) public pure returns(uint8[] memory) {
        uint8[] memory traits = new uint8[](48);
        uint256 i;
        for(i = 0; i < 48; i++) {
            traits[i] = _get5Bits(_genes, i);
        }
        return traits;
    }
    
     /// @dev given a number get a slice of any bits, at certain offset
    /// @param _n a number to be sliced
    /// @param _nbits how many bits long is the new number
    /// @param _offset how many bits to skip
    function _sliceNumber(uint256 _n, uint256 _nbits, uint256 _offset) private pure returns (uint256) {
        // mask is made by shifting left an offset number of times
        uint256 mask = uint256((2**_nbits) - 1) << _offset;
        // AND n with mask, and trim to max of _nbits bits
        return uint256((_n & mask) >> _offset);
    }
}