assert = require 'assert'

Error = require '../error'
Ast = require '../parser/ast'
Stack = require './stack'
{ mapFunctions, executeFunction } = require './function'
io = require './io'

{ NODES } = Ast

module.exports = @

@load = (root) ->
        assert root?
        mapFunctions root

@run = =>
    try
        status = executeFunction 'main', new Ast(NODES.PARAM_LIST, [])
    catch error
        io.output io.STDERR, error.message
        status = error.code
    finally
        { status, stdout: io.stdout, stderr: io.stderr }
