const HDWalletProvider = require('truffle-hdwallet-provider')
const Web3 = require('web3')
const {interface, bytecode} = require('./compile')

const provider =  new HDWalletProvider(
    'issue planet wonder jealous emerge fabric purse rely tonight unhappy fold elevator',
    'https://rinkeby.infura.io/v3/18c25be0ecce41fd81fcb320101aaca9'
)

const web3 = new Web3(provider);//THIS WEB3 IS CONNECTED TO RINKEBY NOW

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();
    deployedContract = await new web3.eth.Contract(JSON.parse(interface))
        .deploy({data: '0x' + bytecode}) // add 0x bytecode
        .send({from: accounts[0], gas: '1000000'}); 
    deployedContract.setProvider(provider);
    console.log('Contract Deployed to ',deployedContract.options.address)
}
deploy()