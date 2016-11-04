assert = require 'assert'

Stack = require './stack'
Ast   = require '../parser/ast'
Func = require './function'
error = require '../error'
valueParser = require '../parser/value-parser'
{ callStack, dataStack, returnStack } = require './vm-state'
io = require './io'

{ NODES, OPERATORS, LITERALS, CASTS, STATEMENTS } = Ast

module.exports = @

prepareAST = (T) ->
    return if not T?
    stackAux = []
    stackAux.push T

    while stackAux.length > 0
        root = stackAux.pop()
        callStack.push root
        stackAux.push root.right() if not root.isLeaf() and root.right()?
        stackAux.push root.left() if not root.isLeaf() and root.left()?

@evaluateExpression = e = (untreatedT) ->
    prepareAST untreatedT
    while callStack.length > 0
        T = callStack.pop()
        switch T.getType()
            when OPERATORS.PLUS
                dataStack.push(dataStack.pop() + dataStack.pop())
            when OPERATORS.MINUS
                dataStack.push(dataStack.pop() - dataStack.pop())
            when OPERATORS.MUL
                dataStack.push(dataStack.pop() * dataStack.pop())
            when OPERATORS.INT_DIV
                div = dataStack.pop()
                den = dataStack.pop()
                if den is 0
                    throw error.DIVISION_BY_ZERO
                dataStack.push(div // den)
            when OPERATORS.DOUBLE_DIV
                dataStack.push(dataStack.pop() / dataStack.pop())
            when OPERATORS.MOD
                div = dataStack.pop()
                den = dataStack.pop()
                if den is 0
                    throw error.MODULO_BY_ZERO
                dataStack.push(div % den)
            when OPERATORS.UPLUS
                dataStack.push(+dataStack.pop())
            when OPERATORS.UMINUS
                dataStack.push(-dataStack.pop())
            when OPERATORS.LT
                dataStack.push(dataStack.pop() < dataStack.pop())
            when OPERATORS.LTE
                dataStack.push(dataStack.pop() <= dataStack.pop())
            when OPERATORS.GT
                dataStack.push(dataStack.pop() > dataStack.pop())
            when OPERATORS.GTE
                dataStack.push(dataStack.pop() >= dataStack.pop())
            when OPERATORS.EQ
                dataStack.push(dataStack.pop() is dataStack.pop())
            when OPERATORS.NEQ
                dataStack.push(dataStack.pop() isnt dataStack.pop())

            when OPERATORS.AND
                dataStack.push(dataStack.pop() and dataStack.pop())
            when OPERATORS.OR
                dataStack.push(dataStack.pop() or dataStack.pop())
            when OPERATORS.NOT
                dataStack.push(not dataStack.pop())


            when LITERALS.BOOL, LITERALS.INT, LITERALS.DOUBLE, LITERALS.STRING, LITERALS.CHAR
                dataStack.push T.child()

            when NODES.ID
                dataStack.push Stack.getVariable(T.child())
            when NODES.IDLHS
                dataStack.push T.child()

            when OPERATORS.ASSIGN
                id    = dataStack.pop()
                value = dataStack.pop()

                Stack.setVariable id, value
                dataStack.push value

            when OPERATORS.POST_INC
                id = dataStack.pop()
                oldValue = Stack.getVariable(id)
                newValue = oldValue + 1
                Stack.setVariable id, newValue
                dataStack.push oldValue

            when OPERATORS.POST_DEC
                id = dataStack.pop()
                oldValue = Stack.getVariable(id)
                newValue = oldValue - 1
                Stack.setVariable id, newValue
                dataStack.push oldValue

            when CASTS.INT2DOUBLE
                dataStack.push dataStack.pop()
            when CASTS.INT2CHAR
                dataStack.push dataStack.pop()
            when CASTS.INT2BOOL
                dataStack.push(dataStack.pop() isnt 0)

            when CASTS.DOUBLE2INT
                dataStack.push(Math.floor dataStack.pop())
            when CASTS.DOUBLE2CHAR
                dataStack.push(Math.floor dataStack.pop())
            when CASTS.DOUBLE2BOOL
                dataStack.push(dataStack.pop() isnt 0)

            when CASTS.CHAR2INT
                dataStack.push dataStack.pop()
            when CASTS.CHAR2BOOL
                dataStack.push(dataStack.pop() isnt 0)
            when CASTS.CHAR2DOUBLE
                dataStack.push dataStack.pop()

            when CASTS.BOOL2INT, CASTS.BOOL2DOUBLE, CASTS.BOOL2CHAR
                dataStack.push(if dataStack.pop() then 1 else 0)

            when CASTS.INT2COUT
                dataStack.push dataStack.pop().toString()
            when CASTS.BOOL2COUT
                dataStack.push(if dataStack.pop() then "1" else "0")
            when CASTS.CHAR2COUT
                dataStack.push(String.fromCharCode(dataStack.pop()))
            when CASTS.DOUBLE2COUT
                double = dataStack.pop()
                if isNaN double
                    val = "-nan" # Yes, C++ gives -nan
                else if double is Number.POSITIVE_INFINITY
                    val = "inf"
                else if double is Number.NEGATIVE_INFINITY
                    val = "-inf"
                else
                    val = double.toString()
                dataStack.push val

            when CASTS.CIN2BOOL
                dataStack.push dataStack.pop()

            when NODES.FUNC_VALUE
                dataStack.push(returnStack.pop())

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
                dataStack.push allRead
            else
                assert false
    dataStack.pop()
