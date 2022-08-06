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
    address public initiator;
    address public daoAddress;
    bytes32 public encodedAddPermittedData;

    constructor(
        Sketch sketch_,
        string memory name_,
        uint256 sketchId_) {
        sketch = sketch_;
        name = name_;
        id = sketchId_;

        initiator = sketch.ownerOf(sketchId_);
        sketch.transferFrom(
            initiator,
            address(this),
            sketchId_);
        createDAO(sketchId_);
        prepareSetPermittedData();
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
            block.timestamp,
            sigs
        );
        daoAddress.staticcall(data);
    }

    function createDAO(uint256 sketchId) private {
        require(msg.sender == tx.origin);
        address[] memory participants = new address[](1);
        participants[0] = initiator;
        uint256[] memory shares = new uint256[](1);
        shares[0] = 1;
        xDaoFactory.create("SlapSketch_123", "SLAP123", 30, participants, shares);
        daoAddress = xDaoFactory.daoAt(xDaoFactory.numberOfDaos() - 1);

    }

    function prepareSetPermittedData() private {
        IDaoExecuteAddPermitted dao = IDaoExecuteAddPermitted(daoAddress);
        bytes memory encodedAddPermitted = abi.encodeWithSelector(dao.addPermitted.selector, address(this));

        bytes32 txHash = getTxHash(daoAddress, encodedAddPermitted, 0, 0, block.timestamp);
    }

    function getTxHash(
        address _target,
        bytes memory _data,
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
