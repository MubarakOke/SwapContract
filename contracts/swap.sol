//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import './IERC20.sol';

contract Swap {
    address owner;
    address tokenAAddress;
    address tokenBAddress;
    uint256 chargesPercentage;
    uint256 conversionRatio;

    event Swapped(address indexed _user, uint256 _amountSwappedTo);

    error ONLY_OWNER();
    error ZERO_ACCOUNT_DETECTED();
    error ZERO_AMOUNT_DETECTED();
    error TOKENA_LIQUIDITY_LOW();
    error TOKENB_LIQUIDITY_LOW();
    error USER_INSUFFICIENT_TOKENA();
    error USER_INSUFFICIENT_TOKENB();
    error SWAPPING_FAILED_USER();
    error SWAPPING_FAILED_CONTRACT();

    constructor(address _tokenAAddress, address _tokenBAddress, uint256 _chargesPercentage, uint256 _conversionRatio){
        owner= msg.sender;
        chargesPercentage= _chargesPercentage;
        conversionRatio= _conversionRatio;
        tokenAAddress= _tokenAAddress;
        tokenBAddress= _tokenBAddress;
    }

    function swapAforB(uint256 _amount ) external returns(bool){
        if (msg.sender == address(0)) { revert ZERO_ACCOUNT_DETECTED();}

        uint256 _amountPlusCharges= _amount + calculateCharges(_amount);
        uint256 _amountConverted= _amount * conversionRatio;

        if (_amount <= 0) {revert ZERO_AMOUNT_DETECTED();}
        if (IERC20(tokenAAddress).balanceOf(msg.sender)  < _amountPlusCharges) {revert USER_INSUFFICIENT_TOKENA();}
        if (IERC20(tokenBAddress).balanceOf(address(this)) < _amountConverted) {revert TOKENB_LIQUIDITY_LOW();}

        if(!IERC20(tokenAAddress).transferFrom(msg.sender, address(0), _amountPlusCharges)) {revert SWAPPING_FAILED_USER();}
        if(!IERC20(tokenBAddress).transfer(msg.sender, _amountConverted)) {revert SWAPPING_FAILED_CONTRACT();}

        emit Swapped(msg.sender, _amountConverted);
        return true;
    }

    function swapBforA(uint256 _amount) external returns(bool){
        if (msg.sender == address(0)) { revert ZERO_ACCOUNT_DETECTED();}

        uint256 _amountPlusCharges= _amount + calculateCharges(_amount);
        uint256 _amountConverted= _amount / conversionRatio;

        if (_amount <= 0) {revert ZERO_AMOUNT_DETECTED();}
        if (IERC20(tokenBAddress).balanceOf(msg.sender)  < _amountPlusCharges) {revert USER_INSUFFICIENT_TOKENA();}
        if (IERC20(tokenAAddress).balanceOf(address(this)) < _amountConverted) {revert TOKENB_LIQUIDITY_LOW();}

        if(!IERC20(tokenBAddress).transferFrom(msg.sender, address(0), _amountPlusCharges)) {revert SWAPPING_FAILED_USER();}
        if(!IERC20(tokenAAddress).transfer(msg.sender, _amountConverted)) {revert SWAPPING_FAILED_CONTRACT();}

        emit Swapped(msg.sender, _amountConverted);
        return true;
    }

    function updateConversionRation(uint256 _conversionRatio) external {
        onlyOwner();
        conversionRatio= _conversionRatio;
    }

    function updateChargesPercentage(uint256 _chargesPercentage) external {
        onlyOwner();
        chargesPercentage= _chargesPercentage;
    }

    function calculateCharges(uint256 _amount) public view returns(uint256){
        return _amount * chargesPercentage/100;
    }

    function onlyOwner() private view {
        if (msg.sender != owner) { revert ONLY_OWNER();}
    }
}