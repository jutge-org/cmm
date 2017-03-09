{ Parser } = require 'jison'
{ readFileSync } = require 'fs'
Ast = require './parser/ast'
{ checkSemantics } = require './semantics/'
interpreter = require './interpreter/'
io = require './interpreter/io'
Stack = require './interpreter/stack'
{ stepInto, stepOver, stepOut } = require './debugger/steps'
fs = require 'fs'


BASE = __dirname
GRAMMAR_PATH = "#{BASE}/parser/grammar.jison"

grammar = readFileSync GRAMMAR_PATH, "utf-8"
parser = new Parser grammar
parser.yy = { Ast }

@compile = (code) ->
    try
        ast = parser.parse code
    catch err
        throw  err.message

    ast = checkSemantics ast

    ast

@execute = (ast, input) ->
    interpreter.load ast

    iterator = interpreter.run(input)

    loop
        { value, done } = iterator.next()
        break unless not done
        yield value: value, stack: Stack.stack
    yield 0

@hooks = {
    setInput: (input) -> io.setInput(io.STDIN, input)
    isInputBufferEmpty: -> io.isInputBufferEmpty(io.STDIN)
    modifyVariable: (stackNumber, varName, value) -> Stack.stack[stackNumber].variables[varName].value = value
}

@events = {
    onstdout: (cb) -> interpreter.onstdout cb
}

@actions = {
    stepOut: -> stepOut()
    stepOver: -> stepOver()
    stepInto: -> stepInto()
}

module.exports = @
