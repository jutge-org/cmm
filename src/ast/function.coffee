assert = require 'assert'

{ Ast } = require './ast'
{ TYPES } = require './type'
{ FunctionVar } = require '../compiler/semantics/function-var'
{ Variable } = require '../compiler/semantics/variable'
Error = require '../error'
utils = require '../utils'
{ Branch } = require './branch'
{ Return } = require './return'

module.exports = @

@Function = class Function extends Ast
    compile: (state) ->
        console.log "Function"

        [ returnType, { children: [ functionId ] }, argList, instructionList ] = @children

        state.newFunction(new FunctionVar functionId, returnType)

        argList.compile state
        
        { instructions: instructionsBody } = instructionList.compile state

        functionVariable = state.getVariable functionId

        functionVariable.instructions = instructionsBody

        state.endFunction()

        return type: TYPES.VOID, instructions: instructionsBody, id: functionId


# TODO: This should basically be a conventional declaration node
@FuncArg = class FuncArg extends Ast
    compile: (state) ->
        console.log "FuncArg"

        [ argType, { children: [ argId ] } ] = @children

        { functionId } = state

        if argType is TYPES.VOID
            throw Error.VOID_FUNCTION_ARGUMENT.complete('function', 'argument', argId)

        func = state.getVariable functionId

        assert func?

        func.argTypes.push argType

        state.defineVariable new Variable argId, argType, isFunctionArgument: yes

        return type: TYPES.VOID, instructions: []