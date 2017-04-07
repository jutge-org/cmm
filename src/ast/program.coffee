assert = require 'assert'

Error = require '../error'
{ Ast } = require './ast'
{ TYPES } = require './type'
{ CompilationState } = require '../compiler/semantics/compilation-state'

module.exports = @

@Program = class Program extends Ast
    ALLOWED_MAIN_RETURN_TYPES = [ TYPES.INT, TYPES.VOID ]

    checkMainIsDefined = (definedVariables) ->
        main = definedVariables.main?[0]
        if not main? or main.type isnt TYPES.FUNCTION
            throw Error.MAIN_NOT_DEFINED
        else if main.returnType not in ALLOWED_MAIN_RETURN_TYPES
            throw Error.INVALID_MAIN_TYPE

    compile: ->
        console.log "Program"

        [ functionList ] = @children

        # Holds information about the current state of the compilation
        state = new CompilationState

        functionList.compile state

        console.log state.functions

        for funcId, func of state.functions
            console.log "#{funcId}:"

            for instruction in func.instructions
                console.log instruction.toString()

        checkMainIsDefined state.definedVariables

        this