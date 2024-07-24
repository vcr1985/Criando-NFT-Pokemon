PokeDIO
PokeDIO é um contrato inteligente baseado no padrão ERC721 para criar e batalhar com Pokémons no blockchain. Este contrato foi desenvolvido utilizando a biblioteca OpenZeppelin para implementar as funcionalidades de tokens não fungíveis (NFTs).

Instalação
Para compilar e implantar o contrato, você precisa do Node.js e npm. Primeiro, clone o repositório e instale as dependências:

bash
Copiar código
git clone https://github.com/seu-usuario/pokeDIO.git
cd pokeDIO
npm install
Estrutura do Contrato
O contrato PokeDIO herda do contrato ERC721 da OpenZeppelin e define as seguintes funcionalidades:

Pokémon: Uma estrutura para armazenar o nome, nível e imagem de um Pokémon.
pokemons: Um array público que contém todos os Pokémons criados.
gameOwner: O endereço do dono do jogo, que tem permissões especiais para criar novos Pokémons.
Construtor: Define o dono do jogo e o nome/símbolo do token.
Modificador onlyOwnerOf: Verifica se o chamador é o dono de um Pokémon específico.
Função battle: Permite que um Pokémon ataque outro Pokémon. O nível dos Pokémons é ajustado com base no resultado da batalha.
Função createNewPokemon: Permite ao dono do jogo criar novos Pokémons.
Funções
createNewPokemon
solidity
Copiar código
function createNewPokemon(string memory _name, address _to, string memory _img) public
Cria um novo Pokémon com o nome e imagem especificados e o atribui ao endereço _to. Esta função só pode ser chamada pelo dono do jogo.

battle
solidity
Copiar código
function battle(uint _attackingPokemon, uint _defendingPokemon) public onlyOwnerOf(_attackingPokemon)
Inicia uma batalha entre dois Pokémons. O chamador deve ser o dono do Pokémon atacante. Os níveis dos Pokémons são ajustados com base no resultado da batalha.

Como Usar
Implantação
Para implantar o contrato na blockchain, use um framework como Hardhat ou Truffle. Abaixo está um exemplo usando Hardhat:

Configure o Hardhat:
bash
Copiar código
npx hardhat
Adicione o script de implantação em scripts/deploy.js:
javascript
Copiar código
async function main() {
    const PokeDIO = await ethers.getContractFactory("PokeDIO");
    const pokeDIO = await PokeDIO.deploy();

    await pokeDIO.deployed();

    console.log("PokeDIO deployed to:", pokeDIO.address);
}

main()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error);
    process.exit(1);
});
Execute o script de implantação:
bash
Copiar código
npx hardhat run scripts/deploy.js --network <network-name>
Interação
Após a implantação, você pode interagir com o contrato usando scripts ou ferramentas como Remix ou Ethers.js.

Aqui está um exemplo de como criar um novo Pokémon e iniciar uma batalha usando Ethers.js:

javascript
Copiar código
const { ethers } = require("ethers");

async function main() {
    const provider = new ethers.providers.JsonRpcProvider("<RPC_URL>");
    const wallet = new ethers.Wallet("<PRIVATE_KEY>", provider);
    const pokeDIOAddress = "<DEPLOYED_CONTRACT_ADDRESS>";

    const PokeDIO = new ethers.Contract(
        pokeDIOAddress,
        [
            "function createNewPokemon(string memory _name, address _to, string memory _img) public",
            "function battle(uint _attackingPokemon, uint _defendingPokemon) public"
        ],
        wallet
    );

    // Cria um novo Pokémon
    let tx = await PokeDIO.createNewPokemon("Pikachu", wallet.address, "img_url");
    await tx.wait();

    // Inicia uma batalha
    tx = await PokeDIO.battle(0, 1);
    await tx.wait();
}

main().catch(console.error);


Licença
Este projeto é licenciado sob a licença GPL-3.0. Veja o arquivo LICENSE para mais detalhes.

