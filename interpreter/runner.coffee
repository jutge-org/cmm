massert = require 'assert'

Stack   = require './stack'
Ast     = require '../parser/ast'
{ evaluateExpression } = require './expression'
{ instructionQueue, returnStack, dataStack, cinStack } = require './vm-state'
valueParser = require '../parser/value-parser'
{ initFunction, finalizeFunction } = require './function'
Func = require './function'
io = require './io'

{ NODES, STATEMENTS, OPERATORS } = Ast

module.exports = @

@initRunner = ->
    @openScopes = {}

@getNumberInstructions = ->
    instructionQueue.length

pushInstruction = (T) ->
    instructionQueue.push T

unwrapBlock = (T, closeScope = no) ->
    pushInstruction new Ast NODES.CLOSE_SCOPE, [] if closeScope
    for child in T.getChildren() by -1
        pushInstruction child

executeInstructionHelper = (T) ->
    switch T.getType()
        when NODES.BLOCK_INSTRUCTIONS
            unwrapBlock T
        when NODES.DECLARATION
            declarations = T.getChild 1
            type = T.getChild 0
            for declaration in declarations
                if declaration.getType() is OPERATORS.ASSIGN
                    varName = declaration.child().child()
                    value = evaluateExpression declaration.getChild 1
                    Stack.defineVariable varName, type, value
                else if declaration.getType() is NODES.ID
                    varName = declaration.child()
                    Stack.defineVariable varName, type
        when STATEMENTS.COUT
            for outputItem in T.getChildren()
                io.output io.STDOUT, evaluateExpression(outputItem)
        when STATEMENTS.RETURN
            value = evaluateExpression T.child()
            returnStack.push value
            finalizeFunction()
        when STATEMENTS.NOP
            (->)() # Just add this comment to fill this lonely emptiness...
        when STATEMENTS.IF_THEN
            if evaluateExpression T.left()
                Stack.openNewScope()
                unwrapBlock T.right(), closeScope=yes
        when STATEMENTS.IF_THEN_ELSE
            Stack.openNewScope()
            if evaluateExpression T.left()
                unwrapBlock T.right(), closeScope=yes
            else
                unwrapBlock T.getChild(2), closeScope=yes
        when STATEMENTS.WHILE
            if T.id not of @openScopes
                @openScopes[T.id] = yes
                Stack.openNewScope()
            if evaluateExpression T.left()
                pushInstruction T
                unwrapBlock  T.right()
            else
                Stack.closeScope()
                delete @openScopes[T.id]
        when STATEMENTS.FOR
            if T.id not of @openScopes
                @openScopes[T.id] = yes
                executeInstructionHelper T.getChild(0)
                Stack.openNewScope()
            if evaluateExpression T.getChild(1)
                pushInstruction T
                pushInstruction T.getChild(2)
                unwrapBlock T.getChild(3)
            else
                Stack.closeScope()
                delete @openScopes[T.id]
        when NODES.CLOSE_SCOPE
            Stack.closeScope()
        when NODES.FUNCALL
            initFunction T
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
            cinStack.push allRead
        when NODES.END_FUNC_BLOCK
            (->)()
        else
            evaluateExpression T

@executeInstruction = ->
    while instructionQueue.length > 0
        T = instructionQueue.pop()
        yield T
        executeInstructionHelper T
    yield 0
