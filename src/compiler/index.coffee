{ parse } = require './parser'
{ compile } = require './semantics'

module.exports = @

@compile = (code) ->
    ast = parse code
    program = compile ast

    { program, ast }