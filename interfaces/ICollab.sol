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

interface ICollab {
    struct PieceInfo {
        uint256 index;
        address creator;
        uint256 currentEditionSketchId;
        uint8 totalUpvotes;
        uint8 totalDownvotes;
        mapping(address => bool) upvotes;
        mapping(address => bool) downvotes;
    }

    function claim(uint8 pieceIndex) external;

    function submitPieceEdition(uint8 pieceIndex, uint256 sketchId) external;

    //TODO switch to hybrid voting
    //TODO (optional) switch to bitsets
    function evaluatePieces(uint8[] calldata upvotes, uint8[] calldata downvotes) external returns (uint8);
}
