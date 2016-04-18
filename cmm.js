var fs = require("fs");
var jison = require("jison");

var bnf = fs.readFileSync("parser/grammar.jison", "utf8");
var parser = new jison.Parser(bnf);

function exec(input) {
    return parser.parse(input);
}

var prog = exec("4 * 5");
console.log(prog);