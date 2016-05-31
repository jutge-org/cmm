assert = require 'assert'

Stack = require './stack'
Runner = require './runner'
Ast = require '../parser/ast'
Error = require '../error'

{ NODES, TYPES } = Ast

module.exports = @

# Of the form: { <funcId>: { type: tipus, argIds: [id1, id2, ..., idn] } }
functions = null


@mapFunctions = (T) ->
    functions = {}
    assert.strictEqual T.getType(), NODES.BLOCK_FUNCTIONS
    for functionTree in T.getChildren()
        assert.strictEqual functionTree.getType(), TYPES.FUNCTION
        funcId = functionTree.getChild(1).getChild(0)
        argIds = (argAst.getChild(1).getChild(0) for argAst in functionTree.getChild(2))
        type = functionTree.getChild(0)
        functions[funcId] = { type, argIds }
    return

@executeFunction = (T) ->
    funcId = T.getChild(0).getChild(0)
    argValuesAst = T.getChild(1)
    console.log ('executing ' + funcId)

    assert functions.main?

    func = functions[funcId]

    assert func?, 'Function ' + funcId + ' not declared'

    { type, argIds } = func

    assert argIds.length is argValuesAst.getChildCount()

    Stack.pushActivationRecord()
    for id, i in argIds
        Stack.defineVariable id, argValuesAst.getChild(i).getChild(0)

    result = null
    try
        Runner.executeInstruction func.getChild(3)
    catch maybeError
        if maybeError?.return is yes # The function returned
            { value: result } = maybeError
        else
            throw maybeError # You can omit the maybe

    Stack.popActivationRecord()

    # If main function is executed and no result is returned, value 0 is returned
    if not result?
        if funcId is "main"
            result = 0
        else if type isnt TYPES.VOID
            throw Error.NO_RETURN.complete("name", funcId)

    result
