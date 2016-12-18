assert = require 'assert'

Error = require '../error'
Ast = require '../parser/ast'
Stack = require './stack'
{ mapFunctions, initFunction } = require './function'
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

    initFunction new Ast(NODES.FUNCALL, [new Ast(NODES.ID, ["main"]), new Ast(NODES.PARAM_LIST, [])])
    initRunner()
    iterator = executeInstruction()
    loop
      { value, done } = iterator.next()
      break unless not done
      yield value
      status = value

    yield { status, stderr: io.getStream(io.STDERR) }

@onstdout = (cb) ->
    io.setStdoutCB cb
