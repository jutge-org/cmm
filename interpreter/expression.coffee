assert = require 'assert'

Stack = require './stack'
Ast   = require '../parser/ast'

{ NODES, OPERATORS, LITERALS } = Ast

module.exports = @

@evaluateExpression = e = (T) ->
    assert T?

    switch T.getType()
        when OPERATORS.PLUS
            e(T.left()) + e(T.right())
        when OPERATORS.MINUS
            e(T.left()) + e(T.right())
        when OPERATORS.MUL
            e(T.left()) + e(T.right())
        when OPERATORS.INT_DIV
            e(T.left()) + e(T.right())
        when OPERATORS.DOUBLE_DIV
            e(T.left()) + e(T.right())
        when OPERATORS.MOD
            e(T.left()) + e(T.right())
        when OPERATORS.UPLUS
            e(T.child())
        when OPERATORS.UMINUS
            - e(T.child())
        when OPERATORS.LT
            e(T.left()) < e(T.right())
        when OPERATORS.LTE
            e(T.left()) <= e(T.right())
        when OPERATORS.GT
            e(T.left()) > e(T.right())
        when OPERATORS.GTE
            e(T.left()) >= e(T.right())
        when OPERATORS.EQ
            e(T.left()) is e(T.right())
        when OPERATORS.NEQ
            e(T.left()) isnt e(T.right())
        when OPERATORS.AND
            e(T.left()) and e(T.right())
        when OPERATORS.OR
            e(T.left()) or e(T.right())
        when OPERATORS.NOT
            not e(T.child())
        when LITERALS.BOOL, LITERALS.INT, LITERALS.DOUBLE, LITERALS.STRING, LITERALS.CHAR
            T.child()
        when NODES.ID
            Stack.getVariable(T.child())
        else
            console.log('Expression evaluation not implemented yet')
            null
