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
rl.on('line', function(line){
    var instr = exec(line);
    console.log(instr);
    process.stdout.write(">>> ");
});