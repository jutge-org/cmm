assert = require 'assert'

Stack = require './stack'
Runner = require './runner'
Ast = require '../parser/ast'
{ NODES } = Ast

module.exports = @

funcName2Tree = null

@mapFunctions = (T) ->
    assert.strictEqual T.getType(), NODES.BLOCK_INSTRUCTIONS
    funcName2Tree = {}
    for subTree in T.getChildren()
        assert.strictEqual subTree.getType(), NODES.FUNCTION
        funcName = subTree.getChild(1).getChild(0)
        funcName2Tree[funcName] = subTree
    return

@executeFunction = (funcName, args = null) ->
    console.log ('executing' + funcName)
    assert funcName2Tree.main?
    func = funcName2Tree[funcName]
    assert func?, 'Function ' + funcName + ' not declared'
    arg_values = listArguments(func.getChild(2), args)
    Stack.pushActivationRecord()

    for { id, value } in arg_values
        Stack.defineVariable id, value

    result = Runner.executeListInstructions func.getChild(3)
    Stack.popActivationRecord()
    # If main function is executed and no result is returned, value 0 is returned
    if funcName is 'main' and not result
        return 0
    result

listArguments = (argListAst, args) ->
    for argAst, i in args.getChildren()
        id : argAst.getChild(0)
        value: evaluateExpression(args.getChild(0))
