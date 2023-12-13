---
title: Protocol Audit Report
author: Nacho Díaz
date: December 13, 2023
header-includes:
  - \usepackage{titling}
  - \usepackage{graphicx}
---

\begin{titlepage}
    \centering
    \begin{figure}[h]
        \centering
        
    \end{figure}
    \vspace*{2cm}
    {\Huge\bfseries Protocol Audit Report\par}
    \vspace{1cm}
    {\Large Version 1.0\par}
    \vspace{2cm}
    {\Large\itshape Nacho Díaz\par}
    \vfill
    {\large \today\par}
\end{titlepage}

\maketitle

<!-- Your report starts here! -->

Prepared by: [Nacho Díaz](https://github.com/nachoddiaz)
Lead Auditors: 
- Nacho Díaz

# Table of Contents
- [Table of Contents](#table-of-contents)
- [Protocol Summary](#protocol-summary)
- [Disclaimer](#disclaimer)
- [Risk Classification](#risk-classification)
- [Audit Details](#audit-details)
    - [Commit Hash : 2e8f81e263b3a9d18fab4fb5c46805ffc10a9990](#commit-hash--2e8f81e263b3a9d18fab4fb5c46805ffc10a9990)
  - [Scope](#scope)
  - [Roles](#roles)
- [Executive Summary](#executive-summary)
  - [Issues found](#issues-found)
- [Findings](#findings)
  - [High](#high)
    - [\[H-1\] TITLE: Storging plain text on-chain is vivible to anyone, then not private](#h-1-title-storging-plain-text-on-chain-is-vivible-to-anyone-then-not-private)
      - [Impact:](#impact)
      - [Proof of Concept](#proof-of-concept)
      - [Recommended Mitigation:](#recommended-mitigation)
    - [\[H-2\]``PasswordStore::setPassword`` has not access control, a non-owner could change the password and set a new password](#h-2passwordstoresetpassword-has-not-access-control-a-non-owner-could-change-the-password-and-set-a-new-password)
      - [Description:](#description)
      - [Impact:](#impact-1)
      - [Proof of Concept:](#proof-of-concept-1)
      - [Recommended Mitigation: Add an access control conditional to the `setPassword` function](#recommended-mitigation-add-an-access-control-conditional-to-the-setpassword-function)
  - [Informational](#informational)
    - [\[I-1\] The `PasswordStore::getPassword` natspect indicates there is a parameter `newPassword` that doesn-t exist therefore natspect is incorrect](#i-1-the-passwordstoregetpassword-natspect-indicates-there-is-a-parameter-newpassword-that-doesn-t-exist-therefore-natspect-is-incorrect)
      - [Description:](#description-1)
      - [Impact:](#impact-2)
      - [Recommended Mitigation:](#recommended-mitigation-1)

# Protocol Summary

Protocol does X, Y, Z

# Disclaimer

The Nacho Díaz team makes all effort to find as many vulnerabilities in the code in the given time period, but holds no responsibilities for the findings provided in this document. A security audit by the team is not an endorsement of the underlying business or product. The audit was time-boxed and the review of the code was solely on the security aspects of the Solidity implementation of the contracts.

# Risk Classification

|            |        | Impact |        |     |
| ---------- | ------ | ------ | ------ | --- |
|            |        | High   | Medium | Low |
|            | High   | H      | H/M    | M   |
| Likelihood | Medium | H/M    | M      | M/L |
|            | Low    | M      | M/L    | L   |

We use the [CodeHawks](https://docs.codehawks.com/hawks-auditors/how-to-evaluate-a-finding-severity) severity matrix to determine severity. See the documentation for more details.

# Audit Details 
A smart contract applicatoin for storing a password. Users should be able to store a password and then retrieve it later. Others should not be able to access the password. 

### Commit Hash : 2e8f81e263b3a9d18fab4fb5c46805ffc10a9990

## Scope 
```
./src/
--- PasswordStore.sol
```
## Roles
Owner: The user who can set the password and read the password.<br>
Outsides: No one else should be able to set or read the password.

# Executive Summary
 *How the audit went<br>
 *We spent X hours with Y auditors using Z tools.

## Issues found

| Severity       | Number Of Issues |
| -------------- | ---------------- |
| High           | 2                |
| Medium         | 0                |
| Low            | 0                |
| Infornmational | 1                |
| Total          | 3                |

# Findings
## High
### [H-1] TITLE: Storging plain text on-chain is vivible to anyone, then not private

**Description:** All data stored on-chain is visible to anyoune, and can be read by anyone. The ``PasswordStore::s_password`` in intended to be private and only accessed throug the ``PasswordStore::getPassword`` function. It is to other contracts but not to anyone who can read the blockchain.

Method to read it:

#### Impact:
Cirtical. This bug breaks the functionality of the contract

#### Proof of Concept

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

#### Recommended Mitigation:
The best solution is to encrypt the password onchain and the store it inchain or directly store the password offchain cause the nature of the blockchain is to be public and transparent.

<br><br><br>

### [H-2]``PasswordStore::setPassword`` has not access control, a non-owner could change the password and set a new password

#### Description: 
Everybody can call the ``PasswordStore::setPassword`` function and change the password. The function does not have any access control. The ``PasswordStore::setPassword`` function is intended to be called only by the owner of the contract.

```javascript
    function setPassword(string memory newPassword) external {
        s_password = newPassword;
        emit SetNetPassword();
    }
```

#### Impact:
Critical, this bug breaks all the funcionality of the contract allowing anyone to change the password

#### Proof of Concept:

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


#### Recommended Mitigation: Add an access control conditional to the `setPassword` function

```javascript
if(msg.sender!=owner) return;
```
<br><br><br>



## Informational

### [I-1] The `PasswordStore::getPassword` natspect indicates there is a parameter `newPassword` that doesn-t exist therefore natspect is incorrect



#### Description: 

```javascript
    /*
     * @notice This allows only the owner to retrieve the password.
     * @param newPassword The new password to set.
     */
    function getPassword() external view returns (string memory) {
```
The `PasswordStore::getPassword` function signature is `getPassword()` while the natspect say it should be `getPassword(newPassword)`.

#### Impact:
Incorrect Natspect

#### Recommended Mitigation:
Remove the natspect line

```diff
-   *@param newPassword The new password to set.
```
