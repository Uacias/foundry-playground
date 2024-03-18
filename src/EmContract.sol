// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract MyContract {
    mapping(address => mapping(address => bool)) public approvals;

    function approve(address _wallet) public {
        approvals[msg.sender][_wallet] = true;
    }

    function transferToken(
        IERC20 token,
        address _from,
        address _to,
        uint256 _amount
    ) public {
        require(approvals[msg.sender][_from], "You do not have approval to operate this wallet");
        require(token.transferFrom(_from, _to, _amount), "Transfer failed");
    }
}
