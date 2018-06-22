const assert = require('assert')
const ganache = require('ganache-cli')
const Web3 = require('web3')
const { interface, bytecode } = require('../compiled/LandRegistry.json')

const provider = ganache.provider()
const web3 = new Web3(provider)

let accounts
let contract
beforeEach(async () => {
    accounts = await web3.eth.getAccounts()
    contract = await new web3.eth.Contract(JSON.parse(interface))
        .deploy({ data: bytecode })
        .send({ from: accounts[0], gas: '1000000' })
    contract.setProvider(provider)
})

describe('LandRegistry', () => {
    it('Deploys the contract', async () => {
        assert.ok(contract.options.address)
    })

    it('Creates the Terrain and Polygon', async () => {
        const ownerName = 'Decent Technologies Inc.'
        const result = await contract.methods
            .createTerrain(ownerName)
            .send({ from: accounts[0], gas: '1000000' })
        const { terrainId, owner, registrar } = result.events.NewTerrain.returnValues

        // Assertions
        assert.equal(terrainId, "1")
        assert.equal(owner, ownerName)
        assert.equal(registrar, accounts[0])
    })
})
