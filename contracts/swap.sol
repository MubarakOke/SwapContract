//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import './IERC20.sol';

contract Swap {
    address tokenAAddress;
    address tokenBAddress;
    event Swapped(address indexed _user, uint256 _amount);

    error CONTRACTINSUFFICIENTTOKENA();
    error CONTRACTINSUFFICIENTTOKENB();
    error USERINSUFFICIENTTOKENA();
    error USERINSUFFICIENTTOKENB();

    constructor(addres _tokenAAddress, address _tokenBAddress){
        token1Address= _tokenAAddress;
        token2Address= _tokenBAddress;
    }

    function swapAforB(uint256 _amount ) returns(bool){
        require(msg.sender != address(0));
        if(IERC20(tokenAAddress).balanceOf(msg.sender) > _amount) {revert USERINSUFFICIENTTOKENA();)
    }

    function swapBforA(uint256 _amount) returns(bool){

    }
}