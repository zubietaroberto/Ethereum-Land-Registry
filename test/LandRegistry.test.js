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
        // Create a sample terrain
        const ownerName = 'Decent Technologies Inc.'
        const result = await contract.methods
            .createTerrain(ownerName)
            .send({ from: accounts[0], gas: '1000000' })
        const {
            terrainId,
            owner,
            registrar
        } = result.events.NewTerrain.returnValues

        // Assertions
        assert.equal(terrainId, '1')
        assert.equal(owner, ownerName)
        assert.equal(registrar, accounts[0])

        // Create a Polygon with dummy coordinates
        const coordinateArray = [['13', '14'], ['15', '16'], ['17', '18']]
        for (const coord of coordinateArray) {
            const result2 = await contract.methods
                .addPointToTerrain(terrainId, coord[0], coord[1])
                .send({ from: accounts[1], gas: '1000000' })
            const values = result2.events.NewPolygonPoint.returnValues

            // Assert that the points were created
            assert.equal(values.registrar, accounts[1])
            assert.equal(values.terrainId, terrainId)
        }

        // Query the contract for the amount of points in that polygon,
        // and make sure it is correct.
        const count = await contract.methods
            .getPolygonItemCount(terrainId)
            .call({from: accounts[0] })
        assert.equal(count, coordinateArray.length)
    })
})
