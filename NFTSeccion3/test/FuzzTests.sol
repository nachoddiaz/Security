//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {Counter} from "src/Counter.sol";
contract Invariants is StdInvariant, Test {
    Counter public counter;
    function setUp() public {
        counter = new Counter();
    }

    function testGetValue() public {
        uint256 value = counter.getNewValue();
        console.log(value);
    }
}