assert = require 'assert'

Error = require '../error'
Ast = require '../parser/ast'
Stack = require './stack'
{ mapFunctions, executeFunction } = require './function'

module.exports =
  load: (root) ->
    assert root?
    mapFunctions root
  run: ->
    executeFunction 'main'
