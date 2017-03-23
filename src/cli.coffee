#! /usr/bin/env coffee

fs = require 'fs'

cmm = require '.'

[code, input] = process.argv[2..]

unless code?
    code =
        """
        #include <iostream>
        using namespace std;

        int main) {
            bool found = false;
            int x;
            while (not found and cin >> x) found = x == 2;
            cout << x << endl;
        }
        """
else
    code = fs.readFileSync code

unless input?
    input =
        """
        2 0
        """
else
    input = fs.readFileSync input


# Compile
try
    ast = cmm.compile code
catch error
    error.message = "Semantic error:\n#{error.message}" if error.code isnt 100
    console.log error.message
    process.exit error.code

console.log "Compilation successful:"
console.log ast.toString()

# Run and store output
{ status, stdout, stderr, output } = cmm.execute(ast, input)

# Print result
console.log "exit status code: #{status}"
console.log "stdout:"
process.stdout.write stdout
console.log "stderr:"
process.stdout.write stderr
console.log "Interleaved:"
process.stdout.write output