// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {MyContract} from "../src/EmContract.sol";

contract MyContractTest is Test {
    MyContract public myContract;
    IERC20 public token;
    address public loggedUser;
    address public from;
    address public to;

    function setUp() public {
        loggedUser = address(0xd1405fE8FaEe965075a6F903d773194463da0CfB);
        from = address(0x00000000219ab540356cBB839Cbe05303d7705Fa);
        to = address(0xBE0eB53F46cd790Cd13851d5EFf43D12404d33E8);
        token = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        myContract = new MyContract();
    }

    function testTransferToken() public {
        uint256 transferAmount = 66;
        uint256 initialBalance = token.balanceOf(to);
        vm.prank(loggedUser);
        myContract.approve(from);
        vm.prank(from);
        token.approve(address(myContract), transferAmount);
        vm.prank(loggedUser);
        myContract.transferToken(token, from, to, transferAmount);
        vm.stopPrank();
        assertEq(token.balanceOf(to), initialBalance + transferAmount);
    }

    function testTransferWithoutApproval() public {
        uint256 transferAmount = 66;
        vm.expectRevert();
        myContract.transferToken(token, from, to, transferAmount);
    }

    function testInsufficientBalance() public {
        uint256 transferAmount = token.balanceOf(from) + 1;
        vm.expectRevert();
        myContract.transferToken(token, from, to, transferAmount);
    }
}
