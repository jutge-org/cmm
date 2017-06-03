assert = require 'assert'

Error = require '../error'
{ Ast } = require './ast'
{ PRIMITIVE_TYPES, FunctionType } = require './type'
{ CompilationState } = require '../compiler/semantics/compilation-state'
{ FunctionVar } = require '../compiler/semantics/function-var'
{ Funcall } = require './funcall'
{ Program } = require '../compiler/program'
{ Memory } = require '../runtime/memory'

module.exports = @

{ ENTRY_FUNCTION } = Program

@ProgramAst = class ProgramAst extends Ast
    ALLOWED_MAIN_RETURN_TYPES = [ PRIMITIVE_TYPES.INT ]

    checkMainIsDefined = (functions) ->
        { main } = functions
        unless main? and main.type.isFunction
            throw Error.MAIN_NOT_DEFINED
        else if main.type.returnType not in ALLOWED_MAIN_RETURN_TYPES
            throw Error.INVALID_MAIN_TYPE

    compile: ->
        [ topDeclarationList ] = @children

        # Holds information about the current state of the compilation
        state = new CompilationState

        { instructions } = topDeclarationList.compile state

        { functions, variables, addressOffset: globalsSize } = state

        if globalsSize > Memory.SIZES.heap
            throw Error.MAX_HEAP_SIZE_EXCEEDED.complete('size', globalsSize, 'limit', Memory.SIZES.heap)

        checkMainIsDefined functions

        entryFunction = new FunctionVar ENTRY_FUNCTION, new FunctionType(PRIMITIVE_TYPES.VOID)
        entryFunction.instructions = [ instructions..., new Funcall 'main', 0 ]
        state.newFunction entryFunction
        state.endFunction()

        new Program variables, functions, globalsSize