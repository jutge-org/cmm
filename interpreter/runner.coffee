assert = require 'assert'

Stack   = require './stack'
Ast     = require '../parser/ast'
Eval    = require './expression'
{ NODES, STATEMENTS } = Ast

module.exports = @

funcName2Tree = null

outputString = [""]

@executeListInstructions = (T) ->
    assert T?
    for child in T.getChildren()
        result = executeInstruction child
        result.output = outputString if not result?.output?
        outputString = [""]
        return result if result
    null

executeInstruction = (T) ->
    assert T?
    switch T.getType()
        when NODES.DECLARATION
            declarations = T.getChild 1
            for atom in declarations
                varName = atom.getChild(0).getChild(0)
                if atom.getType() is NODES.ASSIGN
                    value = Eval.evaluateExpression atom.getChild 1
                    Stack.defineVariable varName, value
                else if atom.getType is NODES.ID
                    Stack.defineVariable varName
        when NODES.BLOCK_ASSIGN
            @executeListInstructions T
        when NODES.ASSIGN
            id    = T.getChild 0
            value = Eval.evaluateExpression T.getChild 1
            Stack.setVariable id, value
        when STATEMENTS.COUT
            for outputItem in T.getChildren()
                # TODO: extract constant
                if outputItem.getType() is NODES.ENDL
                    outputString.push("")
                else
                    outputString[outputString.length - 1] += (Eval.evaluateExpression outputItem)
        when STATEMENTS.RETURN
            value: Eval.evaluateExpression(T.getChild 0)
            output: outputString
        else throw 'Instruction ' + T.getType() + ' not implemented yet.'
