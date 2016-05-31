assert = require 'assert'

Stack = require './stack'
Ast   = require '../parser/ast'

{ NODES, OPERATORS, LITERALS } = Ast

module.exports = @

eL = (T) -> e T.getChild 0
eR = (T) -> e T.getChild 1

@evaluateExpression = e = (T) ->
    assert T?

    switch T.getType()
        when OPERATORS.PLUS
            eL(T) + eR(T)
        when OPERATORS.MINUS
            eL(T) - eR(T)
        when OPERATORS.MUL
            eL(T) * eR(T)
        when OPERATORS.INT_DIV
            eL(T) // eR(T)
        when OPERATORS.DOUBLE_DIV
            eL(T) / eR(T)
        when OPERATORS.MOD
            eL(T) % eR(T)
        when LITERALS.BOOL, LITERALS.INT, LITERALS.DOUBLE, LITERALS.STRING, LITERALS.CHAR
            T.getChild 0
        when NODES.ID
            Stack.getVariable(T.getChild 0)
        else
            console.log('Expression evaluation not implemented yet')
            null
