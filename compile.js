const path = require('path')
const fs = require('fs')
const solc = require('solc')
const util = require('util')

const readFile = util.promisify(fs.readFile)
const writeFile = util.promisify(fs.writeFile)

async function execute() {
    const contractPath = path.resolve(
        __dirname,
        'contracts',
        'LandRegistry.sol'
    )
    const outputPath = path.resolve(
        __dirname,
        'compiled',
        'LandRegistry.json'
    )
    const source = await readFile(contractPath, 'utf8')
    const output = solc.compile(source, 1)

    const str = JSON.stringify(output.contracts[':LandRegistry'])
    await writeFile(outputPath, str, 'utf8')
}

execute()
