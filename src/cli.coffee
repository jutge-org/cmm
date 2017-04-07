#! /usr/bin/env coffee

fs = require 'fs'

cmm = require '.'

[ code, input ] = process.argv[2..]

unless code?
    code =
        """
        #include <iostream>
        using namespace std;

        int f(int x, int y) {
            return x+y + 2.0;
        }

        int main() {
            int x = 2*3/4;
            int u;
            int aa, bb, cc;
            aa = bb = cc = 0;
            if (x) {
                cin >> u;
            }

            if (cin >> x) {
                int c = 2+3;
            }
            else {
                int c = 5 + 2;
            }

            while (1) {
                cin >> x;
            }

            int i, a;
            i = 2;
            int c = 3;
            for (int i = 0; i<c;++i) {
                ++a;
            }
            
            int b = 2+f(2+3, 2);

            cout << x << endl;

            return 2;
            /*
            //bool found = false;
            ;;;
            ;
            f(2, '3');
            while (x > -0.5);

            if (2) {
                int a = x++/--x;
                int b = ++x%x--;
            }

            for (int p = 2; p; p) {
            }

            int p;
            if (not 3) {
                string s = "dwdaw";
            }
            else {
                int b = 0.2;
            }

            cout << x << endl;*/
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
    console.time "Compilation"
    ast = cmm.compile code
    console.timeEnd "Compilation"
catch error
    error.message = "Semantic error:\n#{error.message}" if error.code isnt 100
    console.log error.message
    console.log error.stack
    process.exit error.code

console.log "Compilation successful:"

###
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
###
