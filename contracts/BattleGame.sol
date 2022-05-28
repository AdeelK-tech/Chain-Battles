// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract BattleGame is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private tokenId;
    struct Statistics {
        uint256 level;
        uint256 speed;
        uint256 attack;
        uint256 defense;
    }
    mapping(uint => Statistics) public tokenIdtoStatistics;

    constructor() ERC721("battleGame", "BTG") {}

    function getLevels(uint _tokenId) public view returns (string memory) {
        Statistics storage warrior = tokenIdtoStatistics[_tokenId];
        return warrior.level.toString();
    }

    function getAttacks(uint _tokenId) internal view returns (string memory) {
        Statistics storage warrior = tokenIdtoStatistics[_tokenId];
        return warrior.attack.toString();
    }

    function getDefense(uint _tokenId) internal view returns (string memory) {
        Statistics storage warrior = tokenIdtoStatistics[_tokenId];
        return warrior.defense.toString();
    }

    function getSpeed(uint _tokenId) internal view returns (string memory) {
        Statistics storage warrior = tokenIdtoStatistics[_tokenId];
        return warrior.speed.toString();
    }

    // GENERATES SVG IMAGE FOR A TOKEN AND RETURNS 64 BIT HEXADECIMAL
    function generateCharacter(uint _tokenId)
        public
        view
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            getLevels(_tokenId),
            "</text>",
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Speed: ",
            getSpeed(_tokenId),
            "</text>",
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Attack: ",
            getAttacks(_tokenId),
            "</text>",
            '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Defense: ",
            getDefense(_tokenId),
            "</text>",
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    // GENERATES TOKEN COMPLETE METADATA FOR A TOKEN AND RETURNS 64 BIT HEXADECIMAL
    function getTokenURI(uint _tokenId) internal view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            _tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(_tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        tokenId.increment();
        uint t_Id = tokenId.current();
        _safeMint(msg.sender, t_Id);
        uint attack = uint(keccak256(abi.encodePacked(msg.sender))) % 100;
        uint defense = uint(
            keccak256(abi.encodePacked(block.timestamp, t_Id))
        ) % 100;
        uint speed = uint(
            keccak256(abi.encodePacked(block.timestamp,block.difficulty))
        ) % 100;
        tokenIdtoStatistics[t_Id] = Statistics(0, speed, attack, defense);
        _setTokenURI(t_Id, getTokenURI(t_Id));
    }

    // INCREASES LEVEL
    function train(uint _tokenId) public {
        require(_exists(_tokenId), "This token does not exist");
        require(
            ownerOf(_tokenId) == msg.sender,
            "Only ownner can train its character"
        );
        Statistics storage warrior = tokenIdtoStatistics[_tokenId];
        warrior.level++;
        warrior.attack+=5;
        warrior.defense+=5;
        warrior.speed+=10;
        _setTokenURI(_tokenId, getTokenURI(_tokenId));
    }
}
