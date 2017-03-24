{ parse } = require './parser'
{ checkSemantics } = require './semantics'

module.exports = @

@compile = (code) ->
    parsingAst = parse code
    ast = checkSemantics parsingAst

    ast
