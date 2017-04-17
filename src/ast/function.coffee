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
{ Declaration } = require './declaration'

module.exports = @

lastLocations = (locations) ->
    {
        lines: {first: locations.lines.last, last: locations.lines.last}
        columns: {first: locations.columns.last, last: locations.columns.last}
    }

@Function = class Function extends Ast
    compile: (state) ->
        [ returnType, { children: [ functionId ] }, argList, instructionList ] = @children

        state.newFunction(new FunctionVar functionId, returnType)

        argList.compile state
        
        { instructions: instructionsBody } = instructionList.compile state

        functionVariable = state.getFunction functionId

        # Main returns 0 by default
        if functionId is 'main'
            returnOassign = new Assign(MemoryReference.from(TYPES.INT, null, MemoryReference.RETURN), new IntLit(0))
            returnOassign.locations = lastLocations(@locations)

            instructionsBody.push returnOassign

        # Ensure that all methods return. By default they all return 0 if no previous return has been specified.
        # This can be improved with a control flow analysis algorithm which could detect whether a previous return
        # has been specified
        returnInstruction = new Return
        returnInstruction.locations = lastLocations(@locations)
        instructionsBody.push returnInstruction

        functionVariable.instructions = instructionsBody

        state.endFunction()

        return type: TYPES.VOID, instructions: instructionsBody, id: functionId


# TODO: This should basically be a conventional declaration node
@FuncArg = class FuncArg extends Declaration
    constructor: (specifiers, id) ->
        super specifiers, [id] # Switch to declaration format

    compile: (state) ->
        { type } = @getSpecifiers()
        [ _, [ { children: [ argId ] } ] ] = @children

        { functionId } = state

        if type is TYPES.VOID
            throw Error.VOID_FUNCTION_ARGUMENT.complete('function', functionId, 'argument', argId)

        if type is TYPES.STRING
            throw { generated: yes }

        func = state.getFunction functionId

        assert func?

        func.argTypes.push type

        super state