# [C-1] TITLE: Storging plain text on-chain is vivible to anyone, then not private

**Description:** All data stored on-chain is visible to anyoune, and can be read by anyone. The ``PasswordStore::s_password`` in intended to be private and only accessed throug the ``PasswordStore::getPassword`` function. It is to other contracts but not to anyone who can read the blockchain.

Method to read it:

## Impact:
Cirtical. This bug breaks the functionality of the contract

## Proof of Concept

The below test cae shows how ``PasswordStore::s_password`` can be read by anyone.

1. Create a locally running chain

```bash
run anvil
```

2. In a new terminal deploy the contract and read the password

```
make deploy
cast storage "address of the deployed contract" "slot of the variable" --rpc-url http://127.0.0.1:8545
```
We receive a string like this: ``0x6d7950617373776f726400000000000000000000000000000000000000000014`` which is the hex representation of ``myPassword``. We can convert it to a string using the following command:
```
cast parse-bytes32-string 0x6d7950617373776f726400000000000000000000000000000000000000000014
```
Then  we receive the password in plain text:``myPassword``

## Recommended Mitigation:
The best solution is to encrypt the password onchain and the store it inchain or directly store the password offchain cause the nature of the blockchain is to be public and transparent.

<br><br><br><br><br>

# [C-2]``PasswordStore::setPassword`` has not access control, a non-owner could change the password and set a new password

## Description: 
Everybody can call the ``PasswordStore::setPassword`` function and change the password. The function does not have any access control. The ``PasswordStore::setPassword`` function is intended to be called only by the owner of the contract.

```javascript
    function setPassword(string memory newPassword) external {
        s_password = newPassword;
        emit SetNetPassword();
    }
```

## Impact:
Critical, this bug breaks all the funcionality of the contract allowing anyone to change the password

## Proof of Concept:

The below test case shows how ``PasswordStore::setPassword`` can be called by anyone:

<details>
<summary> Code </summary>

 ```javascript
  function test_not_owner_can_set_password() public {
        vm.startPrank(notOwner);
        string memory passowrd = "Im not the owner";
        passwordStore.setPassword(passowrd);
        vm.stopPrank();
        vm.startPrank(owner);
        string memory actualPassword = passwordStore.getPassword();
        assertEq(actualPassword, passowrd);
    }
```

</details>


## Recommended Mitigation: Add an access control conditional to the `setPassword` function

```javascript
if(msg.sender!=owner) return;
```
<br><br><br><br><br>

# [I-1] The `PasswordStore::getPassword` natspect indicates there is a parameter `newPassword` that doesn-t exist therefore natspect is incorrect

## Description: 

```javascript
    /*
     * @notice This allows only the owner to retrieve the password.
     * @param newPassword The new password to set.
     */
    function getPassword() external view returns (string memory) {
```
The `PasswordStore::getPassword` function signature is `getPassword()` while the natspect say it should be `getPassword(newPassword)`.

## Impact:
Incorrect Natspect

## Recommended Mitigation:
Remove the natspect line

```diff
-   *@param newPassword The new password to set.
```