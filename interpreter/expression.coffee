assert = require 'assert'

Stack = require './stack'
Ast   = require '../parser/ast'

{ NODES, OPERATORS, LITERALS, CASTS } = Ast

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

        when CASTS.INT2DOUBLE
            T.child()
        when CASTS.INT2CHAR
            T.child()
        when CASTS.INT2BOOL
            T.child() isnt 0

        when CASTS.DOUBLE2INT
            Math.floor T.child()
        when CASTS.DOUBLE2CHAR
            Math.floor T.child()
        when CASTS.DOUBLE2BOOL
            T.child() isnt 0

        when CASTS.CHAR2INT
            T.child()
        when CASTS.CHAR2BOOL
            T.child() isnt 0
        when CASTS.CHAR2DOUBLE
            T.child()

        when CASTS.BOOL2INT
            if T.child() then 1 else 0
        when CASTS.BOOL2DOUBLE
            if T.child() then 1 else 0
        when CASTS.BOOL2CHAR
            if T.child() then 1 else 0

        when CASTS.INT2COUT
            T.child().toString()
        when CASTS.BOOL2COUT
            if T.child() then "1" else "0"
        when CASTS.CHAR2COUT
            String.fromCharCode(T.child())
        when CASTS.DOUBLE2COUT
            T.child().toString()
        else
            console.log('Expression evaluation not implemented yet')
            null
