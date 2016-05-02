var fs = require("fs");
var jison = require("jison");
var bnf = fs.readFileSync("parser/grammar.jison", "utf8");
var p = new jison.Parser(bnf);
var assert = require('chai').assert;
var expect = require('chai').expect;
var fs = require('fs');

var EXAMPLES_ROOT = 'examples/'

// Encapsulate a set of 
// instructions inside a function
function ef(s) {
	return 'int main () { ' + s + '}';
}

describe('Parser', function() {
    describe('assignments', function () {
        it('should accept expressions as assignment rhs', function () {
            assert.isTrue(p.parse(ef('a = 3+2;')));
            assert.isTrue(p.parse(ef('a = -a/3;')));
            assert.isTrue(p.parse(ef('a = 5*a-(+2-9*b);')));
        });
    });
    describe('functions', function() {
    	it('should only accept programs constituted of functions', function() {
    		var program = "int foo() { a=1;}"
    		assert.isTrue(p.parse(program));

    		var wrongProgram = "a=1;";
    		var res;
    		try {
    		    res = p.parse(wrongProgram);
    		} catch (e) {
    		    res = false;
    		}
    		//var fn = function(){p.parse(wrongProgram)};
    		//assert.throws(fn);
    		assert.isFalse(res);

    		program += "double foo() {b = 51-c;}"
    		assert.isTrue(p.parse(program));
    	});
    });
    describe('example tests', function() {
        it('should pass test 1', function() {
            var examplePath = EXAMPLES_ROOT + 'test1.cc' 
            var example = fs.readFileSync(examplePath, 'utf8').toString();

            var res;
            try {
                res = p.parse(example);
            } catch (e) {
                res = false;
            }
            assert.isTrue(res);
        });
    });
});


