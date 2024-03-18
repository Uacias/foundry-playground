// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {MyContract} from "../src/EmContract.sol";

contract MyContractTest is Test {
    MyContract public myContract;
    IERC20 public token;
    address public from;
    address public to;

    function setUp() public {
        from = address(0x00000000219ab540356cBB839Cbe05303d7705Fa);
        to = address(0xBE0eB53F46cd790Cd13851d5EFf43D12404d33E8);
        token = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        myContract = new MyContract();
    }

    function testTransferToken() public {
        uint256 transferAmount = 66;
        uint256 initialBalance = token.balanceOf(to);
        vm.prank(from);
        token.approve(address(myContract), transferAmount);
        myContract.transferToken(token, from, to, transferAmount);

        assertEq(token.balanceOf(to), initialBalance + transferAmount);
    }

    function testNonApproveTransferToken() public {
        uint256 transferAmount = 66;
        uint256 initialBalance = token.balanceOf(to);
        vm.expectRevert();        
        myContract.transferToken(token, from, to, transferAmount);

    }
}
