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

interface IXDAOFactory {
    function create(
        string memory _daoName,
        string memory _daoSymbol,
        uint8 _quorum,
        address[] memory _partners,
        uint256[] memory _shares
    ) external returns (bool);

    function numberOfDaos() external view returns (uint256);

    function daoAt(uint256 _i) external view returns (address);
}
