assert = require 'assert'

Error = require '../error'
Ast = require '../parser/ast'
Stack = require './stack'
{ mapFunctions, initFunction, finalizeFunction } = require './function'
{ initRunner, executeInstruction } = require './runner'
io = require './io'

{ NODES } = Ast

module.exports = @

@load = (root) ->
    assert root?
    mapFunctions root

@run = (input) ->
    io.reset()
    io.setInput(io.STDIN, input)

    try
        instructions = initFunction new Ast(NODES.FUNCALL, [new Ast(NODES.ID, ["main"]), new Ast(NODES.PARAM_LIST, [])])
        initRunner instructions
        iterator = executeInstruction()
        loop
          { value, done } = iterator.next()
          yield value
          break unless not done
          status = value
        finalizeFunction()
    catch error
        console.error error.stack ? error.message ? error
        io.output io.STDERR, error.message
        status = error.code

    yield { status, stderr: io.getStream(io.STDERR) }

@onstdout = (cb) ->
    io.setStdoutCB cb
