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

interface IDaoExecuteAddPermitted {
    function execute(
        address _target,
        bytes calldata _data,
        uint256 _value,
        uint256 _nonce,
        uint256 _timestamp,
        bytes[] memory _sigs
    ) external returns (bool);

    function addPermitted(address p) external returns (bool);
}
