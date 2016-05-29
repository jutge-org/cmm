var fs = require("fs");
var jison = require("jison");
var bnf = fs.readFileSync("parser/grammar.jison", "utf8");
var p = new jison.Parser(bnf);
p.yy = require("../interp/ast-tree");
var assert = require('chai').assert;
var expect = require('chai').expect;

var EXAMPLES_ROOT = 'examples/';

// Encapsulate a set of 
// instructions inside a function
function ef(s) {
	return 'int main () { ' + s + '}';
}

describe('Parser', function() {
    describe('assignments', function () {
        it('should accept expressions as assignment rhs', function () {
            var fn = function(){p.parse(ef('a = 3asd2;'))};
            assert.throws(fn, Object);
            fn = function() {p.parse(ef('a = 5*a-(+2-9*b);'))};
            assert.doesNotThrow(fn, Object);
        });
    });
    describe('functions', function() {
    	it('should only accept programs constituted of functions', function() {
    		var program = "int foo() { a=1;}";
            var fn = function(){p.parse(program);};
    		assert.doesNotThrow(fn, Object);

    		var wrongProgram = "a=1;";
    		fn = function(){p.parse(wrongProgram);};
            assert.throws(fn, Object);

    		program += "double foo() {b = 51-c;}";
            fn = function(){p.parse(program);};
            assert.doesNotThrow(fn, Object);
    	});
    });
    describe('example tests', function() {
        it('should parse test 1', function() {
            var examplePath = EXAMPLES_ROOT + 'test1.cc';
            var example = fs.readFileSync(examplePath, 'utf8').toString();

            var fn = function () {res = p.parse(example);};
            assert.doesNotThrow(fn, Object);
        });
    });
});


