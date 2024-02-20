//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import './IERC20.sol';

contract Swap {
    address token1Address;
    address token2Address;
    event Swapped(address indexed _user, uint256 _amount);

    error

    constructor(addres _token1Address, address _token2Address){
        token1Address= _token1Address;
        token2Address= _token2Address;
    }

    function swapAforB(uint256 _amount ) returns(bool){
        require(msg.sender != address(0));
        require(IERC20())
    }

    function swapBforA(uint256 _amount) returns(bool){

    }
}