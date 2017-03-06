{ Parser } = require 'jison'
{ readFileSync } = require 'fs'
Ast = require './parser/ast'
{ checkSemantics } = require './semantics/'
interpreter = require './interpreter/'
io = require './interpreter/io'
Stack = require './interpreter/stack'
{ stepInto, stepOver, stepOut } = require './debugger/steps'

GRAMMAR_PATH = './parser/grammar.jison'

grammar = readFileSync GRAMMAR_PATH, "utf-8"
parser = new Parser grammar
parser.yy = { Ast }

compile = (code) ->
    ast = parser.parse code
    ast = checkSemantics ast
    ast

execute = (ast, input) ->
    interpreter.load ast

    iterator = interpreter.run(input)

    loop
        { value, done } = iterator.next()
        break unless not done
        yield value: value, stack: Stack.stack
    yield 0

hooks = {
    setInput: (input) -> io.setInput(io.STDIN, input)
    isInputBufferEmpty: -> io.isInputBufferEmpty(io.STDIN)
    modifyVariable: (stackNumber, varName, value) -> Stack.stack[stackNumber].variables[varName].value = value
}

events = {
    onstdout: (cb) -> interpreter.onstdout cb
}

actions = {
    stepOut: -> stepOut()
    stepOver: -> stepOver()
    stepInto: -> stepInto()
}


code = """
int main(){
    int x = 2;
    x = 3;
}
"""
try
    compile(code)
    console.log "COMPILED"
catch error
    console.log error

execute(code)
