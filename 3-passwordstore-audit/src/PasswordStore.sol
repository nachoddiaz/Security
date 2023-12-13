// SPDX-License-Identifier: MIT
pragma solidity 0.8.18; //q is this the correct version?

/*
 * @author not-so-secure-dev
 * @title PasswordStore
 * @notice This contract allows you to store a private password that others won't be able to see. 
 * You can update your password at any time.
 */
contract PasswordStore {
    // n Si no siguiera convención ,podríamos marcarlo
    error PasswordStore__NotOwner();

    ////////////////////////////////////////
    //          State Variables           //
    ////////////////////////////////////////

    address private s_owner;
    // @audit-done - Everybody can see the state of the blockchain thus get the password
    // even if the variable is private
    //Attack vector: key not encrypted
    string private s_password;

    ////////////////////////////////////////
    //              Events                //
    ////////////////////////////////////////

    event SetNetPassword();

    ////////////////////////////////////////
    //          Constructor               //
    ////////////////////////////////////////
    constructor() {
        s_owner = msg.sender;
    }

    /*
     * @notice This function allows only the owner to set a new password.
     * @param newPassword The new password to set.
     */
    // @audit-done - Everybody can set the password, not only the owner
    //Attack vector: missing access control
    function setPassword(string memory newPassword) external {
        if(msg.sender!=s_owner) {return;}
        s_password = newPassword;
        emit SetNetPassword();
    }

    /*
     * @notice This allows only the owner to retrieve the password.
     * @audit-info There is no param in this function
     * @param newPassword The new password to set.
     */
    function getPassword() external view returns (string memory) {
        if (msg.sender != s_owner) {
            revert PasswordStore__NotOwner();
        }
        return s_password;
    }
}
