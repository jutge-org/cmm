assert = require 'assert'

{ Ast } = require './ast'
{ TYPES, ensureType } = require './type'
{ Assign } = require './assign'
{ MemoryReference } = require './memory-reference'
{ Program: { ENTRY_FUNCTION } } = require '../compiler/program'

module.exports = @

@Return = class Return extends Ast
    compile: (state) ->
        [ value ] = @children

        # Comprovar/castejar que retorna el mateix tipus que el de la funció en la que estem
        # Si la funció en la que estem retorna void sa danar al tanto
        # Retorna void

        { functionId } = state

        func = state.getFunction functionId

        assert func?

        { returnType: expectedType } = func

        if value? # return (something);
            { type: actualType, instructions: valueInstructions, result: valueResult } = value.compile state
            { result, instructions: castingInstructions } = ensureType valueResult, actualType, expectedType, state   
            state.releaseTemporaries result
            instructions = [ valueInstructions..., castingInstructions..., new Assign(MemoryReference.from(expectedType, null, MemoryReference.RETURN), result) ]
        else # return;i
            actualType = TYPES.VOID
            instructions = []

        instructions.push new Return

        return {
            type: TYPES.VOID,
            instructions
        }

    execute: (state) ->
        { function: func, instruction, temporariesOffset } = state.controlStack.pop()

        state.pointers.temporaries = temporariesOffset
        state.pointers.instruction = instruction

        state.function = func
        state.pointers.stack -= state.function.stackSize
        state.instructions = state.function.instructions

        state.finished = state.function.id is ENTRY_FUNCTION