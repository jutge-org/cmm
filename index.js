#!/usr/bin/env node
 
var fs = require("fs");
var jison = require("jison");
var readline = require('readline');

var bnf = fs.readFileSync("parser/grammar.jison", "utf8");
var parser = new jison.Parser(bnf);

function exec(input) {
    return parser.parse(input);
}

var rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false
});

process.stdout.write(">>> ");
//process.stdout.write(exec("int main() {}"));

rl.on('line', function(line){
    try {
        var instr = exec(line);
        console.log(instr);
    } catch(err) {
        console.error(err.message);
    }
    finally {
        process.stdout.write(">>> ");
    }
});