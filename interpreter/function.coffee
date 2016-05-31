assert = require 'assert'

Stack = require './stack'
Runner = require './runner'
Ast = require '../parser/ast'
Error = require '../error'

{ NODES, TYPES } = Ast

module.exports = @

# Of the form: { funcName: { type: tipus, argIds: [id1, id2, ..., idn] } }
functions = null


@mapFunctions = (T) ->
    functions = {}
    assert.strictEqual T.getType(), NODES.BLOCK_FUNCTIONS
    for functionTree in T.getChildren()
        assert.strictEqual functionTree.getType(), TYPES.FUNCTION
        funcName = functionTree.getChild(1).getChild(0)
        argIds = (argAst.getChild(1).getChild(0) for argAst in functionTree.getChild(2))
        type = functionTree.getChild(0)
        functions[funcName] = { type, argIds }
    return

@executeFunction = (funcName, argValuesAst) ->
    console.log ('executing ' + funcName)

    assert functions.main?

    func = functions[funcName]

    assert func?, 'Function ' + funcName + ' not declared'

    { type, argIds } = func

    assert argIds.length is argValuesAst.getChildCount()

    Stack.pushActivationRecord()
    for id, i in argIds
        Stack.defineVariable id, argValuesAst.getChild(i).getChild(0)

    result = Runner.executeInstruction func.getChild(3)

    Stack.popActivationRecord()

    # If main function is executed and no result is returned, value 0 is returned
    if not result?
        if funcName is "main"
            result = 0
        else if type isnt TYPES.VOID
            throw Error.NO_RETURN.complete("name", funcName)

    result
