//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Swap {
    address token1Address;
    address token2Address;
    event Swapped(address indexed _user, uint256 _amount);

    constructor(token){

    }

    function swapAforB(uint256 _amount ) returns(bool){
        require(msg.sender != address(0));
        require()
    }

    function swapBforA(uint256 _amount) returns(bool){

    }
}