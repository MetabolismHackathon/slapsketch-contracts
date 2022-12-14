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
import "./Collab.sol";

contract Factory is Ownable {
    Sketch sketch;
    mapping(uint256 => Collab) public collabs;

    function setSketch(Sketch _sketch) public onlyOwner {
        sketch = _sketch;
    }

    /**
    @notice accept a sketch NFT and create a new Collab contract
    */
    function createCollab(uint256 sketchId, string memory name, uint8 rows, uint8 columns) public returns (address, bytes memory){
        Collab collab = new Collab(sketch, name, sketchId, rows, columns);
        collabs[sketchId] = collab;
        sketch.transferFrom(msg.sender, address(collab), sketchId);

        return (address(collab), collab.encodedAddPermittedData());
    }
}
