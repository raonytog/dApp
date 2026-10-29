//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Turing is ERC20 {
    address public owner;
    bool public voting = true;

    mapping(string => address) public users;
    mapping(address => string) public codinomeOf;
    mapping(string => uint) public userVotedNtimes;
    mapping(string => mapping(string => bool)) public hasVote;

    constructor() ERC20("Turing", "TUR") {
        owner = msg.sender;
        
        _setUser("roberta", 0x502542668aF09fa7aea52174b9965A7799343Df7);
        _setUser("nome1",   0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        _setUser("nome2",   0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        _setUser("nome3",   0x90F79bf6EB2c4f870365E785982E1f101E93b906);
        _setUser("nome4",   0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65);
        _setUser("nome5",   0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc);
    }

    modifier permisionManager() {
        require(msg.sender == owner || msg.sender == users["roberta"], "Only owner or professora");
        _;
    }

    function _setUser(string memory codinome, address addr) internal {
        address old = users[codinome];
        if (old != address(0)) delete codinomeOf[old];
        users[codinome] = addr;
        codinomeOf[addr] = codinome;
    }

    // qtde em Turings inteiros; converte para a menor unidade (18 casas)
    function _mintTuring(address to, uint qtde) internal {
        _mint(to, qtde * 10 ** decimals());
    }

    function updateUser(string memory codinome, address user_addr) public permisionManager {
        require(bytes(codinome).length > 0, "Codinome should not be empty");
        _setUser(codinome, user_addr);
    }

    function votingOn() public permisionManager { voting = true; }
    function votingOff() public permisionManager { voting = false; }

    function issueToken(string memory codinome, uint qtde_de_Turings) public permisionManager {
        require(users[codinome] != address(0), "Codinome not authorized");
        require(qtde_de_Turings > 0, "Quantity should be bigger than 0");
        _mintTuring(users[codinome], qtde_de_Turings);
    }

    function vote(string memory codinome, uint qtde_de_Turings) public {
        require(voting, "Voting should be active");
        string memory voter = codinomeOf[msg.sender];
        require(bytes(voter).length > 0, "Caller is not authorized");
        require(users[codinome] != address(0), "Target codinome does not exist");
        require(users[codinome] != msg.sender, "You can not vote for yourself");
        require(qtde_de_Turings > 0 && qtde_de_Turings <= 2, "Quantity must be 1 or 2");
        require(!hasVote[voter][codinome], "Already voted for this codinome");

        hasVote[voter][codinome] = true;
        userVotedNtimes[voter] += 1;

        _mintTuring(users[codinome], qtde_de_Turings);
        if (userVotedNtimes[voter] % 10 == 0) _mintTuring(msg.sender, 1);
    }
}