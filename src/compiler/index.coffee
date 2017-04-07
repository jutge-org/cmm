{ parse } = require './parser'
{ checkSemantics } = require './semantics'

module.exports = @

@compile = (code) ->
    console.time "Code"
    parsingAst = parse code
    console.timeEnd "Code"
    console.time "Semantics"
    ast = checkSemantics parsingAst
    console.timeEnd "Semantics"

    ast
