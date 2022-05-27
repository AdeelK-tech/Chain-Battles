// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
contract BattleGame is ERC721URIStorage{
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private tokenId;
    mapping (uint=>uint) public tokenIdtoLevels;
    constructor()ERC721("battleGame","BTG"){

    }
    function getLevels(uint _tokenId)internal view returns(string memory){
        uint level=tokenIdtoLevels[_tokenId];
        return level.toString();
    }
    function generateCharacter(uint _tokenId)public view returns(string memory){
      bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(_tokenId),'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
    }
    function getTokenURI(uint _tokenId)internal view returns (string memory){
        bytes memory dataURI=abi.encodePacked(
            '{',
            '"name": "Chain Battles #', _tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(_tokenId), '"',
        '}'
        );
        return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
    }
    function mint()public{
        tokenId.increment();
        uint t_Id=tokenId.current();
        _safeMint(msg.sender, t_Id);
        tokenIdtoLevels[t_Id]=0;
        _setTokenURI(t_Id, getTokenURI(t_Id));
        
    }
    function train(uint _tokenId)public{
        require(_exists(_tokenId),"This token does not exist");
        require(ownerOf(_tokenId)==msg.sender,"Only ownner can train its character");
        tokenIdtoLevels[_tokenId]++;
        _setTokenURI(_tokenId, getTokenURI(_tokenId));

    }
}