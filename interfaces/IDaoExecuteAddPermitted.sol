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
