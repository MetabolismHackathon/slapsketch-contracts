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
import "../interfaces/IDaoExecuteAddPermitted.sol";


contract Collab {
    IXDAOFactory constant xDaoFactory = IXDAOFactory(0x72cc6E4DE47f673062c41C67505188144a0a3D84);

    Sketch sketch;
    string public name;
    uint256 public id;
    address public daoAddress;
    bytes32 public setPermittedData;

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

        createDAO(sketchId_);
        prepareSetPermittedData();
    }

    function createDAO(uint256 sketchId) private {
        address initiator = msg.sender;
        require(msg.sender == tx.origin);
        xDaoFactory.create("SlapSketch_123", "SLAP123", 30, [initiator], [1]);
        daoAddress = xDaoFactory.daoAt(xDaoFactory.numberOfDaos() - 1);

    }

    function prepareSetPermittedData() private {
        IDaoExecuteAddPermitted dao = IDaoExecuteAddPermitted(daoAddress);
        bytes encodedAddPermitted = abi.encodeWithSelector(dao.addPermitted.selector, address(this));

        bytes32 txHash = getTxHash(dao, encodedAddPermitted, 0, 0, block.timestamp);
    }

    function getTxHash(
        address _target,
        bytes calldata _data,
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
