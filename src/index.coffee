{ Parser } = require 'jison'
{ readFileSync } = require 'fs'
Ast = require './parser/ast'
{ checkSemantics } = require './semantics/'
interpreter = require './interpreter/'
io = require './interpreter/io'
Stack = require './interpreter/stack'

BASE = __dirname
GRAMMAR_PATH = "#{BASE}/parser/grammar.jison"

grammar = readFileSync GRAMMAR_PATH, "utf-8"
parser = new Parser grammar
parser.yy = { Ast }

module.exports = @

@compile = (code) ->
    ast = parser.parse code
    ast = checkSemantics ast
    ast

@execute = (ast, input) ->
    interpreter.load ast
    interpreter.run input