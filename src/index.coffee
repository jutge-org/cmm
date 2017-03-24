{ parser } = require './parser/grammar'
Ast = require './parser/ast'
{ checkSemantics } = require './semantics/'
interpreter = require './interpreter/'
Error = require './error'

parser.yy = { Ast }

module.exports = @

@compile = (code) ->
    try
        ast = parser.parse code
    catch error
        throw Error.PARSE_ERROR.complete('error', error.message)

    ast = checkSemantics ast
    ast

@execute = (ast, input) ->
    interpreter.load ast
    interpreter.run input