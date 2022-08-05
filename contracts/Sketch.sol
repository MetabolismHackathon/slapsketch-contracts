/*
  _________.__                    ___________           __         .__
 /   _____/|  | _____  ______    /   _____/  | __ _____/  |_  ____ |  |__
 \_____  \ |  | \__  \ \____ \   \_____  \|  |/ // __ \   __\/ ___\|  |  \
 /        \|  |__/ __ \|  |_> >  /        \    <\  ___/|  | \  \___|   Y  \
/_______  /|____(____  /   __/  /_______  /__|_ \\___  >__|  \___  >___|  /
        \/           \/|__|             \/     \/    \/          \/     \/
*/
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/utils/Counters.sol";

interface IXDAOFactory {
    function create(
        string memory _daoName,
        string memory _daoSymbol,
        uint8 _quorum,
        address[] memory _partners,
        uint256[] memory _shares
    ) external returns (bool);
}

contract Sketch is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor() ERC721("SlapSketch", "SLAP") {}

    function startSketch(string memory jsonMeta) public returns (uint256){
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, jsonMeta);
        return newItemId;
    }

    address private constant XDaoContractPoligonAddress = 0x72cc6E4DE47f673062c41C67505188144a0a3D84;

    function create(
        string memory _daoName,
        string memory _daoSymbol,
        uint8 _quorum,
        address[] memory _partners,
        uint256[] memory _shares
    ) external returns (bool) {
        return IXDAOFactory(XDaoContractPoligonAddress).create(_daoName, _daoSymbol, _quorum, _partners, _shares);
    }
}
