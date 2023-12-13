// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Counter{
    error S3__WrongValue();

    uint256 private constant STARTING_NUMBER = 123;
    uint256 private constant STORAGE_LOCATION = 777;

    constructor(address registry) {
        assembly {
            sstore(STORAGE_LOCATION, STARTING_NUMBER)
        }
    }

    /*
     * CALL THIS FUNCTION!
     * 
     * @param valueAtStorageLocationSevenSevenSeven - The value at storage location 777.
     * @param yourTwitterHandle - Your twitter handle. Can be a blank string.
     */
    function solveChallenge(uint256 valueAtStorageLocationSevenSevenSeven, string memory yourTwitterHandle) external {
        uint256 value;
        assembly {
            value := sload(STORAGE_LOCATION)
        }
        if (value != valueAtStorageLocationSevenSevenSeven) {
            revert S3__WrongValue();
        }
        // slither-disable-next-line weak-prng
        uint256 newValue =
            uint256(keccak256(abi.encodePacked(msg.sender, block.prevrandao, block.timestamp))) % 1_000_000;
        assembly {
            sstore(STORAGE_LOCATION, newValue)
        }
    }

}