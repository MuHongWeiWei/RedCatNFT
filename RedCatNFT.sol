// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract RedCat is ERC721Enumerable, Ownable {

    string _baseTokenURI;
    uint public maxSupply = 10000;
    uint public price = 0.3 ether;

    struct RedCatData {
        uint rarity;
        bool ban;
        bool unbox;
        uint buyTime;
    }

    address stevenAddress = 0xAc4Ff7E04ce061826AAD93f826509D3d9E96682D;

    event Adpot(address owner, uint tokenId);
    event Ban(uint _tokenId);
    event ReleaseBan(uint _tokenId);
    event Unboxing(uint _tokenId, uint _rarity);

    mapping (uint => RedCatData) redCats;
    
    constructor(string memory baseURI) ERC721("RedCat", "RCN") {
        setBaseURI(baseURI);
      
        for(uint256 i = 0; i <= 1; i++) {
            _safeMint(stevenAddress, i); 
            redCats[i] = RedCatData(4, false, true, block.timestamp);           
        }
        getAirDropNFT();
    }

    function adopt(uint256 _num) public payable {
        uint256 supply = totalSupply();
        require(_num == 1, "You can adopt a maximum of 1 Cats");
        require(supply + _num <= maxSupply, "Exceeds maximum Cats supply" );
        require(msg.value >= price * _num, "Ether sent is not correct" );

        for(uint256 i; i < _num; i++) {
            _safeMint(msg.sender, supply + i);
            redCats[supply + i] = RedCatData(0, false, false, block.timestamp);
            emit Adpot(msg.sender, supply + i); 
        }                  
    }

    function unboxing(uint _tokenId, uint _rarity) public {
        require(_tokenId < totalSupply(), "not that much");

        redCats[_tokenId].rarity = _rarity;
        redCats[_tokenId].unbox = true;
        emit Unboxing(_tokenId, _rarity);
    }

    function ban(uint _tokenId) public onlyOwner {
        redCats[_tokenId].ban = true;
        emit Ban(_tokenId);
    }

    function releaseBan(uint _tokenId) public onlyOwner {
        redCats[_tokenId].ban = false;
        emit ReleaseBan(_tokenId);
    }

    function addMaxSupply(uint _num) public onlyOwner {
        maxSupply = maxSupply + _num;
    }

    function setPrice(uint _price) public onlyOwner {
        price = _price;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }
  
    function withdrawAll() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
    
    function getAirDropNFT() private {
        for(uint256 i = 2; i <= 11; i++) {
           _safeMint(stevenAddress, i);        
        }
        redCats[2] = RedCatData(0, false, true, block.timestamp);
        redCats[3] = RedCatData(0, false, true, block.timestamp);
        redCats[4] = RedCatData(0, false, true, block.timestamp);
        redCats[5] = RedCatData(1, false, true, block.timestamp);
        redCats[6] = RedCatData(0, false, true, block.timestamp);
        redCats[7] = RedCatData(0, false, true, block.timestamp);
        redCats[8] = RedCatData(0, false, true, block.timestamp);
        redCats[9] = RedCatData(0, false, true, block.timestamp);
        redCats[10] = RedCatData(0, false, true, block.timestamp);
        redCats[11] = RedCatData(2, false, true, block.timestamp);
    }

    function walletOfOwner(address _owner) public view returns(uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);
        uint256[] memory tokensId = new uint256[](tokenCount);
        for(uint256 i; i < tokenCount; i++){
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokensId;
    }

    function getRarity(uint _tokenId) public view returns (uint, uint) {
        require(_tokenId < totalSupply());
        return (_tokenId, redCats[_tokenId].rarity);
    }

    function getBuyTime(uint _tokenId) public view returns (uint, uint) {
        require(_tokenId < totalSupply());    
        return (_tokenId, redCats[_tokenId].buyTime);
    }

    function getUnboxing(uint _tokenId) public view returns (uint, bool) {
        require(_tokenId < totalSupply());   
        return (_tokenId, redCats[_tokenId].unbox);
    }

    function getBan(uint _tokenId) public view returns (uint, bool) {
        require(_tokenId < totalSupply());    
        return (_tokenId, redCats[_tokenId].ban);
    }

    function getRedCat(uint _tokenId) public view returns (uint , RedCatData memory redCatData) {
        require(_tokenId < totalSupply());
        return (_tokenId, redCats[_tokenId]);
    }
         
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }
}