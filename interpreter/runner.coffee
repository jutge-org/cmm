assert = require 'assert'

Stack = require './stack'
Ast = require '../parser/ast'
{ NODES } = Ast

module.exports = @

funcName2Tree = null

@executeListInstructions = (T) ->
    assert T?
    for child in T.getChildren()
        result = executeInstruction child
        return result if result
        
    null

executeInstruction = (T) ->
    assert T?
    console.log(T.getType())
    switch T.getType()
        when 'TYPE-DECL'
            type = T.getChild 0
            decl = T.getChild 1
            for atom in decl
                varName = atom.getChild 0
                if atom.getType is 'ASSIGN'
                    value = evaluateExpression atom.getChild, 1
                    # TODO: Data?
                    value = new Data type value
                    stack.defineVariable varName, value
                else if atom.getType is 'ID'
                    stack.defineVariable(varName, new Data type)
        when 'BLOCK-ASSIGN'
            executeListInstructions T
        when 'ASSIGN'
            id    = T.getChild 0
            data  = stack.getVariable id
            value = evaluateExpression T.getChild 1
            data.setValue value
        when 'COUT'
            console.log T.getChild 0
            for outputItem in T.getChild 0
                console.log outputItem
                # TODO: extract constant
                if outputItem is 'endl' 
                    console.log outputItem
                    outputString.add '\n'
                else 
                    console.log(evaluateExpression outputItem)
                    outputString.add(evaluateExpression outputItem)
        when 'RETURN'
            return evaluateExpression(T.getChild 0)
        else throw 'Instruction ' + T.getType() + ' not implemented yet.'
            

@executeFunction = (funcName, args = null) ->
    assert funcName2Tree.main?
    func = funcName2Tree[funcName]
    assert func?, 'Function ' + funcName + ' not declared'
    arg_values = listArguments(func.getChild(2), args)
    Stack.pushActivationRecord()

    for { id, value } in arg_values
        Stack.defineVariable id, value

    result = instruction.executeListInstructions func.getChild(3)
    Stack.popActivationRecord()
    # If main function is executed and no result is returned, value 0 is returned
    if funcName is 'main' and not result
        return 0
    result

listArguments = (argListAst, args) ->
    for argAst, i in args.getChildren()
        id : argAst.getChild(0)
        value: evaluateExpression(args.getChild(0))
