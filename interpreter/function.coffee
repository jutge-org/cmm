assert = require 'assert'

Stack = require './stack'
Ast = require '../parser/ast'
Error = require '../error'
Expression = require './expression'
{ instructionQueue } = require './vm-state'


{ NODES, TYPES } = Ast

module.exports = @

# Of the form: { <funcId>: { type: tipus, argTypes: [ty1, ty2, ..., tyn] argIds: [id1, id2, ..., idn], instructions: instruccions } }
functions = null

@getFunctionMap = -> functions

@mapFunctions = (T) ->
    functions = {}
    assert.strictEqual T.getType(), NODES.BLOCK_FUNCTIONS
    for functionTree in T.getChildren()
        assert.strictEqual functionTree.getType(), TYPES.FUNCTION
        funcId = functionTree.getChild(1).getChild(0)
        argTypes = (argAst.getChild(0) for argAst in functionTree.getChild(2).getChildren())
        argIds = (argAst.getChild(1).getChild(0) for argAst in functionTree.getChild(2).getChildren())
        type = functionTree.getChild(0)
        functions[funcId] = { type, argTypes, argIds, instructions: functionTree.getChild(3) }
    return

@initFunction = (T) ->
    funcId = T.getChild(0).getChild(0)
    argValuesAst = T.getChild(1)

    assert functions.main?

    func = functions[funcId]

    assert func?, 'Function ' + funcId + ' not declared'

    { type, argTypes, argIds, instructions } = func

    assert argIds.length is argValuesAst.getChildCount()

    argIdValuePairs =
        for id, i in argIds
            type: argTypes[i]
            id: id
            value: Expression.evaluateExpression(argValuesAst.getChild(i))

    result = null

    Stack.pushActivationRecord(funcId, argIds)

    for { type, id, value } in argIdValuePairs
        Stack.defineVariable id, type, value, param=yes

    instructionQueue.push new Ast NODES.END_FUNC_BLOCK, []
    instructionQueue.push instructions

@finalizeFunction = ->
    loop
      instr = instructionQueue.pop()
      break if instr.getType() is NODES.END_FUNC_BLOCK
    Stack.popActivationRecord()
