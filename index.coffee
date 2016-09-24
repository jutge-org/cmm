{ parser } = require './parser/grammar.jison'
{ checkSemantics } = require './semantics/'
interpreter = require './interpreter/'
Ast = require './parser/ast.coffee'

parser.yy = { Ast }

@compile = (code) ->
    ast = parser.parse code
    ast = checkSemantics ast

    ast

@execute = (ast, input) ->
    interpreter.load ast

    interpreter.run(input)

@events = {
    onstdout: (cb) -> interpreter.onstdout cb
}


self.cmm = @
