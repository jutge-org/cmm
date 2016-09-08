{ parser } = require './parser/grammar.jison'
{ checkSemantics } = require './semantics/'
interpreter = require './interpreter/'
Ast = require './parser/ast.coffee'

parser.yy = { Ast }


self.compile = (code) ->
    ast = parser.parse code
    ast = checkSemantics ast

    ast

self.execute = (ast, input) ->
    interpreter.load ast

    interpreter.run(input)
