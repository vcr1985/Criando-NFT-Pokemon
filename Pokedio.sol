// SPDX-License-Identifier: GPL-3.0

// Declaração da versão do compilador Solidity
pragma solidity ^0.8.0;

// Importação do contrato ERC721 da biblioteca OpenZeppelin
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Definição do contrato PokeDIO que herda do ERC721
contract PokeDIO is ERC721 {

    // Estrutura para armazenar informações de cada Pokémon
    struct Pokemon {
        string name;
        uint level;
        string img;
    }

    // Array público para armazenar todos os Pokémons criados
    Pokemon[] public pokemons;

    // Endereço do dono do jogo (quem pode criar novos Pokémons)
    address public gameOwner;

    // Construtor do contrato, define o dono do jogo e o nome/símbolo do token
    constructor () ERC721("PokeDIO", "PKD") {
        gameOwner = msg.sender; // Define o endereço que implantou o contrato como dono do jogo
    }

    // Modificador para verificar se o chamador é o dono de um Pokémon específico
    modifier onlyOwnerOf(uint _monsterId) {
        require(ownerOf(_monsterId) == msg.sender, "Apenas o dono pode batalhar com este Pokemon");
        _;
    }

    // Função para iniciar uma batalha entre dois Pokémons
    // O chamador deve ser o dono do Pokémon atacante
    function battle(uint _attackingPokemon, uint _defendingPokemon) public onlyOwnerOf(_attackingPokemon) {
        // Referências aos Pokémons atacante e defensor
        Pokemon storage attacker = pokemons[_attackingPokemon];
        Pokemon storage defender = pokemons[_defendingPokemon];

        // Lógica de batalha: ajuste dos níveis dos Pokémons com base no resultado
        if (attacker.level >= defender.level) {
            attacker.level += 2; // Atacante ganha 2 níveis se for mais forte ou igual
            defender.level += 1; // Defensor ganha 1 nível
        } else {
            attacker.level += 1; // Atacante ganha 1 nível se for mais fraco
            defender.level += 2; // Defensor ganha 2 níveis
        }
    }

    // Função para criar um novo Pokémon
    // Somente o dono do jogo pode criar novos Pokémons
    function createNewPokemon(string memory _name, address _to, string memory _img) public {
        require(msg.sender == gameOwner, "Apenas o dono do jogo pode criar novos Pokemons"); // Verifica se o chamador é o dono do jogo
        uint id = pokemons.length; // Obtém o novo ID do Pokémon com base no tamanho do array
        pokemons.push(Pokemon(_name, 1, _img)); // Adiciona o novo Pokémon ao array
        _safeMint(_to, id); // Minta um novo token ERC721 e atribui ao endereço especificado
    }
}
