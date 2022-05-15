const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);
//^^removeSync deletes everything in buildPath

const bountyPath = path.resolve(__dirname, 'contracts', 'Bounty.sol');
const source = fs.readFileSync(bountyPath, 'utf8');
//^^Now we have access to updated contract for new compile
const output = solc.compile(source, 1).contracts;

fs.ensureDirSync(buildPath);
//^^ensureDirSync checks to see if a directory exists.
//If it doesn't it creates it for us.

for (let contract in output) {
    fs.outputJsonSync(
        path.resolve(buildPath, contract.replace(':', '') + '.json'),
        output[contract]
    );
    //^^Loop is used to create a Json file for both contracts
}
