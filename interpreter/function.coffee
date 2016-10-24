assert = require 'assert'

Stack = require './stack'
Runner = require './runner'
Ast = require '../parser/ast'
Error = require '../error'
Expression = require './expression'

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
        argIds = (argAst.getChild(1).getChild(0) for argAst in functionTree.getChild(2).getChildren())
        type = functionTree.getChild(0)
        functions[funcId] = { type, argIds, instructions: functionTree.getChild(3) }
    return

@executeFunction = (T) ->
    funcId = T.getChild(0).getChild(0)
    argValuesAst = T.getChild(1)

    assert functions.main?

    func = functions[funcId]

    assert func?, 'Function ' + funcId + ' not declared'

    { type, argIds, instructions } = func

    assert argIds.length is argValuesAst.getChildCount()

    argIdValuePairs =
        for id, i in argIds
            id: id
            value: Expression.evaluateExpression(argValuesAst.getChild(i))

    result = null

    Stack.pushActivationRecord()

    for { id, value } in argIdValuePairs
        Stack.defineVariable id, value

    try
        runner = new Runner(instructions)
        runner.executeInstruction()
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
