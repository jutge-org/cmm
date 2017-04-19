#! /usr/bin/env coffee

fs = require 'fs'

cmm = require '.'

[ code, input ] = process.argv[2..]

unless code?
    code =
        """
        #include <iostream>
        using namespace std;

        int main() {
            cout << "Hello World!" << endl;
        }
        """
else
    code = fs.readFileSync code, 'utf-8'


unless input?
    input =
        """
        """
else
    input = fs.readFileSync input, 'utf-8'

# Compile
try
    { program, ast } = cmm.compile code
catch error
    error.message = "Semantic error:\n#{error.message}" if error.code isnt 100
    console.log error.message
    console.log error.stack if error.stack?
    process.exit error.code

console.log "Compilation successful:"

program.writeInstructions()

# Run and store output
{ stdout, stderr, output, status } = cmm.runSync program, input

# Print result
console.log "exit status code: #{status}"
console.log "stdout:"
process.stdout.write stdout
console.log "stderr:"
process.stdout.write stderr
console.log "Interleaved:"
process.stdout.write output

