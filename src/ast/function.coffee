assert = require 'assert'

{ Ast } = require './ast'
{ TYPES } = require './type'
{ FunctionVar } = require '../compiler/semantics/function-var'
{ Variable } = require '../compiler/semantics/variable'
Error = require '../error'
utils = require '../utils'
{ Return } = require './return'
{ IntLit } = require './literals'
{ Assign } = require './assign'
{ MemoryReference } = require './memory-reference'

module.exports = @

@Function = class Function extends Ast
    compile: (state) ->
        [ returnType, { children: [ functionId ] }, argList, instructionList ] = @children

        state.newFunction(new FunctionVar functionId, returnType)

        argList.compile state
        
        { instructions: instructionsBody } = instructionList.compile state

        functionVariable = state.getFunction functionId

        # Main returns 0 by default
        if functionId is 'main'
            instructionsBody.push new Assign(MemoryReference.from(TYPES.INT, null, MemoryReference.RETURN), new IntLit(0))

        # Ensure that all methods return. By default they all return 0 if no previous return has been specified.
        # This can be improved with a control flow analysis algorithm which could detect whether a previous return
        # has been specified
        instructionsBody.push new Return

        functionVariable.instructions = instructionsBody

        state.endFunction()

        return type: TYPES.VOID, instructions: instructionsBody, id: functionId


# TODO: This should basically be a conventional declaration node
@FuncArg = class FuncArg extends Ast
    compile: (state) ->
        [ argType, { children: [ argId ] } ] = @children

        { functionId } = state

        if argType is TYPES.VOID
            throw Error.VOID_FUNCTION_ARGUMENT.complete('function', 'argument', argId)

        func = state.getFunction functionId

        assert func?
        
        if argType is TYPES.STRING
            throw { generated: yes }

        func.argTypes.push argType

        state.defineVariable new Variable argId, argType, isFunctionArgument: yes

        return type: TYPES.VOID, instructions: []