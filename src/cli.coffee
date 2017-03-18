#! /usr/bin/env coffee

fs = require 'fs'

cmm = require '.'

[code, input] = process.argv[2..]

unless code?
    code =
        """
        #include <iostream>
        using namespace std;

        int main() {
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
ast = cmm.compile code
console.log "AST:"
console.log ast.toString() # Print AST

# Run and store output
iterator = cmm.execute(ast, input)
output = ""
cmm.events.onstdout((partial_output) -> output += partial_output)

loop
    { done } = iterator.next()
    break if done

# Print output
console.log "Output:"
process.stdout.write output
