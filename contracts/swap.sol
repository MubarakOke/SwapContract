//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import './IERC20.sol';

contract Swap {
    address owner;
    address tokenAAddress;
    address tokenBAddress;
    uint256 chargesPercentage;
    uint256 conversionRatio;

    event Swapped(address indexed _user, uint256 _amount);

    error ZERO_ACCOUNT_DETECTED();
    error ZERO_AMOUNT_DETECTED();
    error TOKENA_LIQUIDITY_LOW();
    error TOKENB_LIQUIDITY_LOW();
    error USER_INSUFFICIENT_TOKENA();
    error USER_INSUFFICIENT_TOKENB();

    constructor(address _tokenAAddress, address _tokenBAddress, uint256 _chargesPercentage, uint256 _conversionRatio){
        owner= msg.sender;
        chargesPercentage= _chargesPercentage;
        conversionRatio= _conversionRatio;
        tokenAAddress= _tokenAAddress;
        tokenBAddress= _tokenBAddress;
    }

    function swapAforB(uint256 _amount ) external returns(bool){
        require(msg.sender != address(0));

        uint256 _totalAmount= _amount + calculateCharges(_amount);

        if (_amount >= 0) {revert ZERO_AMOUNT_DETECTED();}
        if (IERC20(tokenAAddress).balanceOf(msg.sender)  < _totalAmount) {revert USER_INSUFFICIENT_TOKENA();}
        if (IERC20(tokenBAddress).balanceOf(address(this)) < _amount) {revert TOKENB_LIQUIDITY_LOW();}


    }

    function swapBforA(uint256 _amount) external returns(bool){

    }

    function updateConversion(uint256 _conversion) external {

    }

    function updateChargesPercentage(uint256 _chargesPercentage) external {
        chargesPercentage= _chargesPercentage;
    }

    function calculateCharges(uint256 _amount) public view returns(uint256){
        return _amount * chargesPercentage/100;
    }
}