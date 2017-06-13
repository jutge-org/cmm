assert = require 'assert'

{ Ast } = require './ast'
{ PRIMITIVE_TYPES } = require './type'
{ Program: { MAIN_FUNCTION } } = require '../compiler/program'
utils = require '../utils'
{ Return } = require './return'
{ IntLit } = require './literals'
{ Assign } = require './assign'
{ MemoryReference } = require './memory-reference'
{ DeclarationGroup } = require './declaration'
{ FunctionDefinition } = require './debug-info'

module.exports = @

lastLocations = (locations) ->
    {
        lines: {first: locations.lines.last, last: locations.lines.last}
        columns: {first: locations.columns.last, last: locations.columns.last}
    }

@Function = class Function extends Ast
    name: "Function"
    compile: (state) ->

        [ declaration, argList, instructionList ] = @children

        state.beginFunctionReturnDefinition()
        declaration.compile(state)
        state.endFunctionReturnDefinition()

        state.beginFunctionArgumentDefinitions() # Array declaration checks are different (first dimension can be ommited)
        argList.compile state
        state.endFunctionArgumentDefinitions()

        { instructions: instructionsBody } = instructionList.compile state

        functionVariable = state.getFunction()

        functionId = functionVariable.id

        # Main returns 0 by default
        if functionId is MAIN_FUNCTION
            returnOassign = new Assign(MemoryReference.from(PRIMITIVE_TYPES.INT, null, MemoryReference.RETURN), new IntLit(0))
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

        return type: PRIMITIVE_TYPES.VOID, instructions: [ new FunctionDefinition(functionId) ], id: functionId # The instructions can be found on state.functions[<function>].instructions


@FuncArg = class FuncArg extends DeclarationGroup
    name: "FuncArg"
    constructor: (specifiers, id) ->
        super specifiers, [id] # Switch to declaration format

    compile: (state) ->
        { type } = @getSpecifiers()

        if type is PRIMITIVE_TYPES.STRING # TODO: Remove when strings are properly implemented
            @compilationError 'STRING_ARGUMENT'

        super state
