//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
contract Invariants is StdInvariant, Test {
    DSCEngine public dscEngine;
    DecentralizedStableCoin public dsc;
    HelperConfig public config;
    Handler handler;

    address weth;
    address wbtc;

    function setUp() external {
       
    }

    function invariant_protocolMustHaveMoreValueThanTotalSuplly() public view {
        
    }
}