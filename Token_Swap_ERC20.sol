// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "./Kaustubh_ERC20_token.sol";
import "./Pranav_ERC20_token.sol";
/*
How to swap tokens

1. Pranav has 100 tokens from PranavCoin "PRA", which is a ERC20 token.
2. Kaustubh has 100 tokens from KaustubhCoin "KAU", which is also a ERC20 token.
3. Pranav and Kaustubh wants to trade 10 PRA for 20 KAU.
4. Pranav or Kaustubh deploys TokenSwap
5. Pranav approves TokenSwap to withdraw 10 tokens from PranavCoin
6. Kaustubh approves TokenSwap to withdraw 20 tokens from KAU
7. Pranav or Kaustubh calls TokenSwap.swap()
8. Pranav and Kaustubh traded tokens successfully.
*/

contract TokenSwap {
    
    IERC20 public PRA_Token;
    address public owner1;
    uint public amount1;
    IERC20 public KAU_Token;
    address public owner2;
    uint public amount2;

    constructor(address _PRA_Token, address _owner1, uint _amount1, address _KAU_Token, address _owner2, uint _amount2) 
        {
            PRA_Token = IERC20(_PRA_Token);
            owner1 = _owner1;
            amount1 = _amount1;
            KAU_Token = IERC20(_KAU_Token);
            owner2 = _owner2;
            amount2 = _amount2;
        }

    function swap() public {
        require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        
        require(PRA_Token.allowance(owner1, address(this)) >= amount1,"Token 1 allowance too low");
        
        require(KAU_Token.allowance(owner2, address(this)) >= amount2,"Token 2 allowance too low");

        _safeTransferFrom(PRA_Token, owner1, owner2, amount1);
        _safeTransferFrom(KAU_Token, owner2, owner1, amount2);
    }

    function _safeTransferFrom(IERC20 token, address sender, address recipient, uint amount) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}
