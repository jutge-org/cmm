chai = require 'chai'
fs = require 'fs'
jison = require 'jison'
should = chai.should()
expect = chai.expect

error = require '../../src/error'
{ mapFunctions, getFunctionMap, initFunction } = require '../../src/interpreter/function'
{ evaluateExpression } = require '../../src/interpreter/expression'
{ checkSemantics } = require '../../src/semantics/'
Stack = require '../../src/interpreter/stack'
Ast = require '../../src/parser/ast'
{ NODES } = Ast

grammar = fs.readFileSync '../../src/parser/grammar.jison', 'utf8'
parser = new jison.Parser grammar
parser.yy = { Ast }

describe 'Function module unit test', ->
  it 'checks simple function mapping', ->
    prog = parser.parse "int main(){}"
    mapFunctions prog.right()
    funcMap = getFunctionMap()
    funcNum = Object.keys(funcMap).length
    funcNum.should.equal 1

  it 'checks main function is there', ->
    prog = parser.parse "int main(){}"
    mapFunctions prog.right()
    funcMap = getFunctionMap()
    main = funcMap.main
    main.should.not.equal undefined

  it 'should fail because main function is not present', ->
    prog = parser.parse "int not_main(){}"
    mapFunctions prog.right()
    fn = -> initFunction new Ast(NODES.FUNCALL, [new Ast(NODES.ID, ["main"]), new Ast(NODES.PARAM_LIST, [])])
    expect(fn).to.throw(Error)

describe 'Expression module unit test', ->
  it 'computes simple expression', ->
    prog = parser.parse "int main() {3+2*4;}"
    prog = checkSemantics prog
    res = evaluateExpression prog.getChild(0).getChild(3).getChild(0)
    res.should.equal 11
  it 'computes an expression with parenthesis', ->
    prog = parser.parse "int main() {(3+2)*4;}"
    prog = checkSemantics prog
    res = evaluateExpression prog.getChild(0).getChild(3).getChild(0)
    res.should.equal 20
  it 'should fail because it divides 0', ->
    prog = parser.parse "int main() {(3+2)/(4-4);}"
    prog = checkSemantics prog
    fn = -> evaluateExpression prog.getChild(0).getChild(3).getChild(0)
    expect(fn).to.throw(error.DIVISION_BY_ZERO)

describe 'Stack module unit test', ->
  it 'pushes an Activation Record', ->
    Stack.pushActivationRecord('test', [])
    Stack.currentAR.should.not.be.equal null
    Stack.stack.length.should.be.equal 1
    Stack.stack[0].should.be.equal Stack.currentAR
  it 'defines a non-valued variable', ->
    Stack.pushActivationRecord('test', [])
    Stack.defineVariable('foo', 'int')
    Stack.currentAR.variables.foo.should.not.be.equal undefined
    should.equal Stack.currentAR.variables.foo.value, null
  it 'defines a valued variable', ->
    Stack.pushActivationRecord('test', [])
    Stack.defineVariable('foo', 'int', 5)
    Stack.currentAR.variables.foo.should.not.be.equal undefined
    Stack.currentAR.variables.foo.value.should.equal 5
