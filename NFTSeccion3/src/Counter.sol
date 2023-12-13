// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import {Test, console} from "forge-std/Test.sol";

contract Counter{
    uint256 newValue = uint256(keccak256(abi.encodePacked(0x9A8b46e3f9d7ebFb60f37D28af3fe1681BEdE739, uint256(17000018015853232), uint256(1702465200)))) % 1_000_000;
    
    function getNewValue() public view returns (uint256) {
        return newValue;
    }
 }
