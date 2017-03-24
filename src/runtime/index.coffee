assert = require 'assert'

{ Ast } = require '../compiler/ast'
{ mapFunctions, executeFunction } = require './function'
io = require './io'

{ NODES } = Ast

module.exports = @

@load = (root) ->
    assert root?
    mapFunctions root

@run = (input) =>
    io.reset()
    io.setInput(io.STDIN, input)

    try
        status = executeFunction new Ast(NODES.FUNCALL, [new Ast(NODES.ID, ["main"]), new Ast(NODES.PARAM_LIST, [])])
    catch error
        io.output io.STDERR, error.message
        status = error.code

    { status, stdout: io.getStream(io.STDOUT), stderr: io.getStream(io.STDERR), output: io.getStream(io.INTERLEAVED) }
