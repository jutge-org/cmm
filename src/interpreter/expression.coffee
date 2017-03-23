assert = require 'assert'

Stack = require './stack'
Ast   = require '../parser/ast'
Func = require './function'
error = require '../error'
valueParser = require '../parser/value-parser'
io = require './io'

{ NODES, OPERATORS, LITERALS, CASTS, STATEMENTS } = Ast

module.exports = @

@evaluateExpression = e = (T) ->
    assert T?

    switch T.getType()
        when OPERATORS.PLUS
            e(T.left()) + e(T.right())
        when OPERATORS.MINUS
            e(T.left()) - e(T.right())
        when OPERATORS.MUL
            e(T.left()) * e(T.right())
        when OPERATORS.INT_DIV
            den = e(T.right())
            if den is 0
                throw error.DIVISION_BY_ZERO
            e(T.left()) // den
        when OPERATORS.DOUBLE_DIV
            e(T.left()) / e(T.right())
        when OPERATORS.MOD
            den = e(T.right())
            if den is 0
                throw error.MODULO_BY_ZERO
            e(T.left()) % e(T.right())
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

        when OPERATORS.ASSIGN
            id    = T.left().left()
            value = e T.right()

            Stack.setVariable id, value
            value

        when OPERATORS.POST_INC
            id = T.left().left()
            oldValue = e T.left()
            newValue = oldValue + 1
            Stack.setVariable id, newValue
            return oldValue

        when OPERATORS.POST_DEC
            id = T.left().left()
            oldValue = e T.left()
            newValue = oldValue - 1
            Stack.setVariable id, newValue
            return oldValue

        when CASTS.INT2DOUBLE
            e(T.child())
        when CASTS.INT2CHAR
            e(T.child())
        when CASTS.INT2BOOL
            e(T.child()) isnt 0

        when CASTS.DOUBLE2INT
            Math.floor e(T.child())
        when CASTS.DOUBLE2CHAR
            Math.floor e(T.child())
        when CASTS.DOUBLE2BOOL
            e(T.child()) isnt 0

        when CASTS.CHAR2INT
            e(T.child())
        when CASTS.CHAR2BOOL
            e(T.child()) isnt 0
        when CASTS.CHAR2DOUBLE
            e(T.child())

        when CASTS.BOOL2INT
            if e(T.child()) then 1 else 0
        when CASTS.BOOL2DOUBLE
            if e(T.child()) then 1 else 0
        when CASTS.BOOL2CHAR
            if e(T.child()) then 1 else 0

        when CASTS.INT2COUT
            e(T.child()).toString()
        when CASTS.BOOL2COUT
            if e(T.child()) then "1" else "0"
        when CASTS.CHAR2COUT
            String.fromCharCode(e(T.child()))
        when CASTS.DOUBLE2COUT
            double = e(T.child())
            if isNaN double
                "-nan" # Yes, C++ gives -nan
            else if double is Number.POSITIVE_INFINITY
                "inf"
            else if double is Number.NEGATIVE_INFINITY
                "-inf"
            else
                double.toString()

        when CASTS.CIN2BOOL
            e(T.child())

        when NODES.FUNCALL
            Func.executeFunction T

        when STATEMENTS.CIN
            allRead = yes
            for inputItem in T.getChildren()
                id = inputItem.child().child()
                word = io.getWord(io.STDIN)
                if word?
                    { leftover, value } = valueParser.parseInputWord word, inputItem.getType()
                    if value?
                        if leftover.length > 0
                            io.unshiftWord(io.STDIN, leftover)

                        Stack.setVariable id, value
                    else
                        Stack.setVariable id, null
                        allRead = no
                else
                    Stack.setVariable id, null
                    allRead = no
            allRead
        else
            assert false
