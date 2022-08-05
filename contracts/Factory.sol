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

import "./Collab.sol";

contract Factory {
    Sketch sketch;
    mapping(uint256 => Collab) public collabs;

    /**
    @notice accept a sketch NFT and create a new Collab contract
    */
    function createCollab(uint256 sketchId, string memory name) public returns (uint256){
        Collab c = new Collab(sketch, name, sketchId);
        collabs[sketchId] = c;
        return sketchId;
    }
}
