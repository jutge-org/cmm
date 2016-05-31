assert = require 'assert'

Stack = require './stack'
Ast   = require '../parser/ast'

{ NODES, OPERATORS, LITERALS } = Ast

module.exports = @

@evaluateExpression = (T) ->
    assert T?
    if T.getType() of OPERATORS and T.getChildCount() is 2
        v1 = @evaluateExpression T.getChild(0)
        v2 = @evaluateExpression T.getChild(1)
    switch T.getType()
        when OPERATORS.PLUS
            v1 + v2
        when OPERATORS.MINUS
            v1 - v2
        when OPERATORS.MUL
            v1 * v2
        when OPERATORS.DIV
            v1 / v2
        when OPERATORS.MOD
            v1 % v2
        when LITERALS.BOOL
            T.getChild(0)
        when LITERALS.INT
            T.getChild(0)
        when LITERALS.STRING 
            T.getChild(0)
        when NODES.ID
            Stack.getVariable(T.getChild 0)
        else 
            console.log('Expression evaluation not implemented yet')
            null