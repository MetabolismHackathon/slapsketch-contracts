/*
  _________.__                    ___________           __         .__
 /   _____/|  | _____  ______    /   _____/  | __ _____/  |_  ____ |  |__
 \_____  \ |  | \__  \ \____ \   \_____  \|  |/ // __ \   __\/ ___\|  |  \
 /        \|  |__/ __ \|  |_> >  /        \    <\  ___/|  | \  \___|   Y  \
/_______  /|____(____  /   __/  /_______  /__|_ \\___  >__|  \___  >___|  /
        \/           \/|__|             \/     \/    \/          \/     \/
*/
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Sketch.sol";

contract Collab {
    Sketch sketch;
    string public name;
    uint256 public id;

    constructor(
        Sketch sketch_,
        string memory name_,
        uint256 sketchId_) {
        sketch = sketch_;
        name = name_;
        id = sketchId_;

        sketch.transferFrom(
            sketch.ownerOf(sketchId_),
            address(this),
            sketchId_);
    }

}
