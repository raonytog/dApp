//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract Turing is ERC20{
    address public owner;
    mapping(string => address) public users;        // usuarios
    mapping(string => bool) public usersWhoVoted;   // usaurios q votaram
    mapping(string => uint) public userVotedNtimes; // qtd de vezes q cada usuario votou
    
    // msg.sender => codinome => bool
    mapping(address => mapping(string => bool)) public hasVote; // map p saber se o usuario ja votou em determinado codinome
    
    bool public voting;

    constructor() ERC20("Turing", "TUR") {  
        owner = msg.sender;

        users['roberta'] = 0x502542668aF09fa7aea52174b9965A7799343Df7;
        users['nome1']   = 0x70997970c51812dc3a010c7d01b50e0d17dc79c8;
        users['nome2']   = 0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc;
        users['nome3']   = 0x90f79bf6eb2c4f870365e785982e1f101e93b906;
        users['nome4']   = 0x15d34aaf54267db7d7c367839aaf71a00a2c6a65;
        users['nome5']   = 0x9965507d1a55bcc2695c58ba16fb37d819b0a4dc;

        usersWhoVoted['roberta'] = false;
        usersWhoVoted['nome1']   = false;
        usersWhoVoted['nome2']   = false;
        usersWhoVoted['nome3']   = false;
        usersWhoVoted['nome4']   = false;
        usersWhoVoted['nome5']   = false;

        userVotedNtimes['roberta'] = 0;
        userVotedNtimes['nome1']   = 0;
        userVotedNtimes['nome2']   = 0;
        userVotedNtimes['nome3']   = 0;
        userVotedNtimes['nome4']   = 0;
        userVotedNtimes['nome5']   = 0;

        voting = true;
    }

    modifier permisionManager() {
        require(msg.sender == owner || msg.sender == users["roberta"], "Only owner or professora");
        _;
    }

    // Atualiza o endereço associado a um codinome
    function updateUser(string memory codinome, address user_addr) public permisionManager() {
        require(bytes(codinome).length > 0, "Codinome should not be empty");
        users[codinome] = user_addr;
    }

    // Ativa a votação
    function votingOn(string memory codinome, address user_addr) public permisionManager() {
        voting = true;
    }

    // Pausa a votação
    function votingOff(string memory codinome, address user_addr) public permisionManager() {
        voting = false;
    }

    // Emite tokens para o codinome
    function issueToken(string memory codinome, uint qtde_de_Turings) public permisionManager() {
        require(bytes(codinome).length > 0, "Codinome should not be empty");
        require(users[codinome] != address(0), "Only users in users table can receive Turings");
        require(qtde_de_Turings > 0, "Turing quantity should be bigger than 0");

        _mint(users[codinome], qtde_de_Turings);
    }

    function vote(string memory codinome, uint qtde_de_Turings) public {
        require(voting, "Voting should be active");  // 1. A votação deve estar ativa
        require(users[codinome] != address(0), "Target codinome does not exist"); // 2. Apenas usuários pré-autorizados podem executar (quem está chamando a função precisa ter um codinome cadastrado)
        require(users[codinome] != msg.sender, "You can not vote yourself"); // 3. Um usuário NÃO pode votar em si mesmo
        require(qtde_de_Turings > 0 && qtde_de_Turings <= 2, "Turing quantity should be bigger than 0 and lower than or equal to 2"); // 4. qtde_de_Turings deve ser maior que 0 e menor ou igual a 2
        require(!hasVote[msg.sender][codinome], "You have already voted for this codinome"); // 5. Um mesmo usuário só pode votar uma vez em um mesmo codinome

        // Regista o voto
        hasVote[msg.sender][codinome] = true;
        usersWhoVoted[codinome] = true;
    }
}