assert = require 'assert'

Stack   = require './stack'
Ast     = require '../parser/ast'
{ evaluateExpression } = require './expression'
Func = require './function'
io = require './io'

{ NODES, STATEMENTS } = Ast

module.exports = @

@executeInstruction = (T) ->
    assert T?
    switch T.getType()
        when NODES.BLOCK_INSTRUCTIONS
            for child in T.getChildren()
                @executeInstruction child
        when NODES.DECLARATION
            declarations = T.getChild 1
            for declaration in declarations
                if declaration.getType() is NODES.ASSIGN
                    varName = declaration.child().child()
                    value = evaluateExpression declaration.getChild 1
                    Stack.defineVariable varName, value
                else if declaration.getType() is NODES.ID
                    varName = declaration.child()
                    Stack.defineVariable varName
        when NODES.BLOCK_ASSIGN
            for child in T.getChildren()
                @executeInstruction child
        when NODES.ASSIGN
            id    = T.left().left()
            value = evaluateExpression T.right()
            Stack.setVariable id, value
        when STATEMENTS.COUT
            for outputItem in T.getChildren()
                io.output io.STDOUT, evaluateExpression(outputItem)
        when STATEMENTS.RETURN
            value = evaluateExpression T.child()
            throw { return: yes, value }
        # TODO: Add expressions here too, and make FUNCALL be an expressions
        # TODO: Remember to add new scopes when handling for*, if, else and while statements
        #       * Its scope needs to handle also the initialization, condition and increment parts of the for statements
        else
            evaluateExpression T
