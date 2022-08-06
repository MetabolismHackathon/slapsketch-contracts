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

import "@openzeppelin/access/Ownable.sol";
import "@openzeppelin/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/utils/Counters.sol";
import "../interfaces/IXDAOFactory.sol";

contract Sketch is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    address public factory;
    Counters.Counter private _tokenIds;
    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor() ERC721("SlapSketch", "SLAP") {}

    function setFactory(address _factory) public onlyOwner {
        factory = _factory;
    }

    function startSketch(string memory jsonMeta) public returns (uint256){
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, jsonMeta);
        return newItemId;
    }

    //    address private constant XDaoContractPoligonAddress = 0x72cc6E4DE47f673062c41C67505188144a0a3D84;
    IXDAOFactory constant xdaoFactory = IXDAOFactory(0x72cc6E4DE47f673062c41C67505188144a0a3D84);

    function create(
        string memory _daoName,
        string memory _daoSymbol,
        uint8 _quorum,
        address[] memory _partners,
        uint256[] memory _shares
    ) external returns (address) {
        xdaoFactory.create(_daoName, _daoSymbol, _quorum, _partners, _shares);
        return xdaoFactory.daoAt(xdaoFactory.numberOfDaos() - 1);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view override returns (bool) {
        address owner = ERC721.ownerOf(tokenId);
        return spender == factory || super._isApprovedOrOwner(spender, tokenId);
    }
}
