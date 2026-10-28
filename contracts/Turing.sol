//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.9;

// We import this library to be able to use console.log
import "hardhat/console.sol";

contract Turing {
    public address owner;
    mapping(string => address) public users;
    mapping(string => bool) public usersWhoVoted;
    public bool voting;

    constructor() {
        users['roberta'] = 0x502542668aF09fa7aea52174b9965A7799343Df7
        users['nome1'] = 0x70997970c51812dc3a010c7d01b50e0d17dc79c8
        users['nome2'] = 0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc
        users['nome3'] = 0x90f79bf6eb2c4f870365e785982e1f101e93b906
        users['nome4'] = 0x15d34aaf54267db7d7c367839aaf71a00a2c6a65
        users['nome5'] = 0x9965507d1a55bcc2695c58ba16fb37d819b0a4dc

        users['roberta'] = false
        users['nome1'] = false
        users['nome2'] = false
        users['nome3'] = false
        users['nome4'] = false
        users['nome5'] = false
    }

    function updateUser(codinome, user_addr) {
        require(codinome == 'roberta' || user_addr == owner, "Should be Roberta or owner")
        users[codinome] = user_addr
    }

    function votingOn() {
        require(codinome == 'roberta' || user_addr == owner, "Should be Roberta or owner")
        voting = True
    }

    function votingOff() {
        require(codinome == 'roberta' || user_addr == owner, "Should be Roberta or owner")

        voting = false
    }

    function issueToken(codinome , qtde_de_Turings) {
        require(codinome == 'roberta' || user_addr == owner, "Should be Roberta or owner")

        //  Ele criará (minting!) a quantidade especificada de Turings na carteira do “codinome”.
    }

    function vote(codinome, qtde_de_Turings) {
        require(voting == True, "Voting should be active")
        require(users[codinome] != null, "Only users in users table can vote")
        require(users[codinome] != owner, "You can not vote yourself")
        require(qtde_de_Turings > 0 && qtde_de_Turings <= 2, "Turing quantity should be bigger than 0 and lower than 2")
        require(usersWhoVoted[codinome] == false, "Each user can only vote once")
    }
}