assert = require 'assert'

{ Ast } = require './ast'
{ PRIMITIVE_TYPES } = require './type'
{ FunctionVar } = require '../compiler/semantics/function-var'
{ Program: { MAIN_FUNCTION } } = require '../compiler/program'
Error = require '../error'
utils = require '../utils'
{ Return } = require './return'
{ IntLit } = require './literals'
{ Assign } = require './assign'
{ MemoryReference } = require './memory-reference'
{ DeclarationGroup } = require './declaration'

module.exports = @

lastLocations = (locations) ->
    {
        lines: {first: locations.lines.last, last: locations.lines.last}
        columns: {first: locations.columns.last, last: locations.columns.last}
    }

@Function = class Function extends Ast
    compile: (state) ->
        [ returnSpecifiers, { children: [ functionId ] }, argList, instructionList ] = @children

        for specifier in returnSpecifiers
            if typeof specifier isnt "string"
                returnType = specifier

        unless returnType
            throw Error.NO_RETURN_TYPE.complete("function", functionId)

        state.newFunction(new FunctionVar functionId, returnType)

        argList.compile state
        
        { instructions: instructionsBody } = instructionList.compile state

        functionVariable = state.getFunction functionId

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

        return type: PRIMITIVE_TYPES.VOID, instructions: [], id: functionId # The instructions can be found on state.functions[<function>].instructions


@FuncArg = class FuncArg extends DeclarationGroup
    constructor: (specifiers, id) ->
        super specifiers, [id] # Switch to declaration format

    compile: (state) ->
        { type } = @getSpecifiers()
        [ _, [ { children: [ argId ] } ] ] = @children

        { functionId } = state

        if type is PRIMITIVE_TYPES.VOID
            throw Error.VOID_FUNCTION_ARGUMENT.complete('function', functionId, 'argument', argId)

        if type is PRIMITIVE_TYPES.STRING
            throw { generated: yes }

        func = state.getFunction functionId

        assert func?

        func.argTypes.push type

        state.isFunctionArgument = yes # Array declaration checks are different (first dimension can be ommited)

        super state

        state.isFunctionArgument = no