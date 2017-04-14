#! /usr/bin/env coffee

fs = require 'fs'

cmm = require '.'

[ code, input ] = process.argv[2..]

unless code?
    code =
        """
        #include <iostream>
        using namespace std;

        // PRE: n enter > 0
        // POST: suma dels divisors de n
        int suma_divisors(int n) {
            int suma = 0;
            for (int i = 1; i <= n/2; ++i) {
                if (n%i == 0) suma += i;
            }
            return suma;
        }

        int main() {
            int n;
            while (cin >> n) {
                cout << n << ": ";
                int popi = suma_divisors(n - 2) + suma_divisors(n) + suma_divisors(n + 2);
                if (popi == n) cout << "popiropis" << endl;
                else if (popi%n == 0) cout << popi/n << "-popiropis" << endl;
                else cout << "res" << endl;
            }
        }
        """
else
    code = fs.readFileSync code


unless input?
    input =
        """
        132
        """
else
    input = fs.readFileSync input


# Compile
try
    { program, ast } = cmm.compile code
catch error
    error.message = "Semantic error:\n#{error.message}" if error.code isnt 100
    console.log error.message
    console.log error.stack
    process.exit error.code

console.log "Compilation successful:"
program.writeInstructions()
#console.log ast.toString()


# Run and store output
{ stdout, stderr, output } = cmm.run program, input

# Print result

#console.log "exit status code: #{status}"
console.log "stdout:"
process.stdout.write stdout
console.log "stderr:"
process.stdout.write stderr
console.log "Interleaved:"
process.stdout.write output

