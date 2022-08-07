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
pragma abicoder v2;

import "./Sketch.sol";
import "../interfaces/xdao/IDaoExecuteAddPermitted.sol";
import "../interfaces/ICollab.sol";

import "@openzeppelin/utils/Address.sol";


contract Collab is ICollab {
    using Address for address;
    uint8 constant public MAX_PIECES_PER_SKETCH = 100;

    IXDAOFactory constant xDaoFactory = IXDAOFactory(0x72cc6E4DE47f673062c41C67505188144a0a3D84);
    uint256 public constant TIMESTAMP = 1659900000;

    Sketch sketch;
    string public name;
    uint256 public id;
    address public initiator;

    address public daoAddress;
    bytes public encodedAddPermittedData;
    bytes32 public txHash;

    uint8 public rows;
    uint8 public columns;
    uint8 public piecesNumber;
    mapping(address => mapping(uint8 => bool)) public upvotes;
    mapping(address => mapping(uint8 => bool)) public downvotes;
    uint8[] public totalUpvotes;
    uint8[] public totalDownvotes;
    address[] public creators;
    bool public isFinalized;

    constructor(
        Sketch sketch_,
        string memory name_,
        uint256 sketchId_,
        uint8 rows_,
        uint8 columns_
    ) {
        sketch = sketch_;
        name = name_;
        id = sketchId_;

        rows = rows_;
        columns = columns_;
        piecesNumber = rows * columns;
        require(piecesNumber <= MAX_PIECES_PER_SKETCH, "Collab: Too many pieces");
        totalUpvotes = new uint8[](piecesNumber);
        totalDownvotes = new uint8[](piecesNumber);
        creators = new address[](piecesNumber);
        initiator = sketch.ownerOf(sketchId_);

        createDAO(sketchId_);
        prepareSetPermittedData();
    }

    function claim(uint8 pieceIndex) external {
        require(pieceIndex < piecesNumber, "Collab: Piece index out of bounds");
        require(creators[pieceIndex] == address(0), "Collab: Piece already claimed");
        require(!isFinalized, "Collab: Collab is finished");
        creators[pieceIndex] = msg.sender;
        //TODO add staking as claim requirement
    }

    function evaluatePieces(uint8[] calldata upvotes_, uint8[] calldata downvotes_) external returns (uint8){
        uint8 totalChanges = 0;
        for (uint8 i = 0; i < upvotes_.length; i++) {
            uint8 pieceId = upvotes_[i];
            if (!upvotes[msg.sender][pieceId]) {
                upvotes[msg.sender][pieceId] = true;
                totalUpvotes[pieceId]++;
                totalChanges++;
            }
        }
        for (uint8 i = 0; i < downvotes_.length; i++) {
            uint8 pieceId = downvotes_[i];
            if (!downvotes[msg.sender][pieceId]) {
                downvotes[msg.sender][pieceId] = true;
                totalDownvotes[pieceId]++;
                totalChanges++;
            }
        }
        return totalChanges;
    }

    function setupPermitted(bytes calldata signature) external {
        bytes[] memory sigs = new bytes[](1);
        sigs[0] = signature;

        bytes memory data = abi.encodeWithSelector(
            IDaoExecuteAddPermitted(daoAddress).execute.selector,
            daoAddress,
            encodedAddPermittedData,
            0,
            0, //TODO nonce
            TIMESTAMP, //TODO block.timestamp,
            sigs
        );
        daoAddress.functionCall(data);
    }

    function createDAO(uint256 sketchId) private {
        address[] memory participants = new address[](1);
        participants[0] = initiator;
        uint256[] memory shares = new uint256[](1);
        shares[0] = 1;
        xDaoFactory.create("SlapSketch_123", "SLAP123", 30, participants, shares);
        daoAddress = xDaoFactory.daoAt(xDaoFactory.numberOfDaos() - 1);

    }

    function prepareSetPermittedData() private {
        IDaoExecuteAddPermitted dao = IDaoExecuteAddPermitted(daoAddress);
        encodedAddPermittedData = abi.encodeWithSelector(dao.addPermitted.selector, address(this));

        txHash = getTxHash(daoAddress, encodedAddPermittedData, 0, 0, TIMESTAMP);
        //TODO block.timestamp);
    }

    function getTxHash(
        address _target,
        bytes storage _data,
        uint256 _value,
        uint256 _nonce,
        uint256 _timestamp
    ) private view returns (bytes32) {
        return
        keccak256(
            abi.encode(
                address(this),
                _target,
                _data,
                _value,
                _nonce,
                _timestamp,
                block.chainid
            )
        );
    }
}
