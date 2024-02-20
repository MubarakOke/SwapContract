//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import './IERC20.sol';

contract Swap {
    address tokenAAddress;
    address tokenBAddress;
    event Swapped(address indexed _user, uint256 _amount);

    error ZERO_ACCOUNT_DETECTED();
    error ZERO_AMOUNT_DETECTED();
    error CONTRACT_INSUFFICIENT_TOKENA();
    error CONTRACT_INSUFFICIENT_TOKENB();
    error USER_INSUFFICIENT_TOKENA();
    error USER_INSUFFICIENTTOKENB();

    constructor(address _tokenAAddress, address _tokenBAddress){
        tokenAAddress= _tokenAAddress;
        tokenBAddress= _tokenBAddress;
    }

    function swapAforB(uint256 _amount ) external returns(bool){
        require(msg.sender != address(0));

        if (IERC20(tokenAAddress).balanceOf(msg.sender) < _amount) {revert USERINSUFFICIENTTOKENA();}
        if (IERC20(tokenBAddress).balanceOf(address(this)) < _amount) {revert CONTRACTINSUFFICIENTTOKENB();}


    }

    function swapBforA(uint256 _amount) external returns(bool){

    }
}