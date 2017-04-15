assert = require 'assert'

Error = require '../error'
{ Ast } = require './ast'
{ TYPES } = require './type'
{ CompilationState } = require '../compiler/semantics/compilation-state'
{ FunctionVar } = require '../compiler/semantics/function-var'
{ Funcall } = require './funcall'
{ Program } = require '../compiler/program'

module.exports = @

{ ENTRY_FUNCTION } = Program

@ProgramAst = class ProgramAst extends Ast
    ALLOWED_MAIN_RETURN_TYPES = [ TYPES.INT ]

    checkMainIsDefined = (functions) ->
        { main } = functions
        if not main? or main.type isnt TYPES.FUNCTION
            throw Error.MAIN_NOT_DEFINED
        else if main.returnType not in ALLOWED_MAIN_RETURN_TYPES
            throw Error.INVALID_MAIN_TYPE

    compile: ->
        [ functionList ] = @children

        # Holds information about the current state of the compilation
        state = new CompilationState

        functionList.compile state

        { functions, variables, addressOffset: globalsSize } = state

        checkMainIsDefined functions

        entryFunction = new FunctionVar ENTRY_FUNCTION, TYPES.VOID
        entryFunction.instructions = [ new Funcall 'main', 0 ]
        state.newFunction entryFunction
        state.endFunction()

        new Program variables, functions, globalsSize