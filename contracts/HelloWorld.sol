// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract HelloWorld {
  
  function print() public pure returns (string memory) {
    return "Hello World!";
  }
  uint256 a=5;
  uint256 b=10;

  function sum(uint256 c,uint256 d) external pure returns (uint256){
    uint256 result = c+d;
    return result;
  }

  address public owner;

  uint256 wallet1 = 100;
  uint256 wallet2 = 0;

  
  constructor(){
    owner = msg.sender;
  }

}
      