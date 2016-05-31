assert = require 'assert'

Error = require '../error'
Ast = require '../parser/ast'
Stack = require './stack'
{ mapFunctions, executeFunction } = require './function'

{ NODES } = Ast

module.exports =
    load: (root) ->
        assert root?
        mapFunctions root
    run: ->
        executeFunction 'main', new Ast(NODES.PARAM_LIST, [])
