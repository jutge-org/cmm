var fs = require("fs");
var jison = require("jison");
var bnf = fs.readFileSync("parser/grammar.jison", "utf8");
var p = new jison.Parser(bnf);

var assert = require('chai').assert;
describe('Parser', function() {
    describe('assignments', function () {
        it('should accept expressions as assignment rhs', function () {
            assert.isTrue(p.parse('a = 3+2;'));
            assert.isTrue(p.parse('a = -a/3;'));
            assert.isTrue(p.parse('a = 5*a-(+2-9*b);'));
        });
    });
});


