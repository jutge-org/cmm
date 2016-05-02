#!/usr/bin/env node
 
var fs = require("fs");
var jison = require("jison");
var readline = require('readline');

var bnf = fs.readFileSync("parser/grammar.jison", "utf8");
var parser = new jison.Parser(bnf);
var interp = require("./interp/interp");
var util = require('util');

parser.yy = require("./interp/ast-tree");

function parse(input) {
    return parser.parse(input);
}

var rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false
});

process.stdout.write(">>> ");
//process.stdout.write(parse("int main() {}"));

rl.on('line', function(line){
    try {
        var instr = parse(line);
        console.log(util.inspect(instr, {showHidden: false, depth: null}));
        interp.load(instr);
        interp.run();
    } catch(err) {
        console.error(err);
    }
    finally {
        process.stdout.write(">>> ");
    }
});