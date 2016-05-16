#!/usr/bin/env node
 
var fs = require("fs");
var jison = require("jison");
var readline = require('readline');
var program = require('commander');

var bnf = fs.readFileSync("parser/grammar.jison", "utf8");
var parser = new jison.Parser(bnf);
var interp = require("./interp/interp");
var util = require('util');

var debug = false,
    file;

parser.yy = require("./interp/ast-tree");

function parse(input) {
    return parser.parse(input);
}

function setDebug() {
    debug = true;
}

program
.version('0.0.0')
    .usage('[options] [<file>]')
    .option('-d, --debug', 'output debug information', setDebug)
    .parse(process.argv);

if (process.argv.length > 2 && process.argv[process.argv.length-1][0] !== '-') {
    var filename = process.argv[process.argv.length-1];
    file = fs.readFileSync(filename, 'utf8');
}



if (file === undefined) {
    var rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
        terminal: false
    });
    
    process.stdout.write(">>> ");

    rl.on('line', function(line){
        try {
            var instr = parse(line);
            if (debug) console.log(util.inspect(instr, {showHidden: false, depth: null}));
            interp.load(instr);
            interp.run();
        } catch(err) {
            console.error(err);
        }
        finally {
            process.stdout.write(">>> ");
        }
    });
} else {
    try {
        var prog = parse(file);
        if (debug) console.log(util.inspect(prog, {showHidden: false, depth: null}));
        interp.load(prog);
        interp.run();
    } catch(err) {
        console.error(err);
    }
    
}
