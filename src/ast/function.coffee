assert = require 'assert'

{ Ast } = require './ast'
{ TYPES } = require './type'
{ FunctionVar } = require '../compiler/semantics/function-var'
{ Variable } = require '../compiler/semantics/variable'
Error = require '../error'
utils = require '../utils'
{ Return } = require './return'

module.exports = @

@Function = class Function extends Ast
    compile: (state) ->
        [ returnType, { children: [ functionId ] }, argList, instructionList ] = @children

        state.newFunction(new FunctionVar functionId, returnType)

        argList.compile state
        
        { instructions: instructionsBody } = instructionList.compile state

        functionVariable = state.getFunction functionId

        instructionsBody.push new Return # Ensure that all functions have an ending return statement

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