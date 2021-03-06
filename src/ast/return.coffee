assert = require 'assert'

{ Ast } = require './ast'
{ PRIMITIVE_TYPES, ensureType } = require './type'
{ Assign } = require './assign'
{ MemoryReference } = require './memory-reference'
{ Program: { MAIN_FUNCTION } } = require '../compiler/program'

module.exports = @

@Return = class Return extends Ast
    name: "Return"
    compile: (state) ->
        [ value ] = @children

        # Comprovar/castejar que retorna el mateix tipus que el de la funció en la que estem
        # Si la funció en la que estem retorna void sa danar al tanto
        # Retorna void

        func = state.getFunction()

        assert func?

        { type: { returnType: expectedType } } = func

        if value? # return (something);
            { type: actualType, instructions: valueInstructions, result: valueResult } = value.compile state
            { result, instructions: castingInstructions } = ensureType valueResult, actualType, expectedType, state, this
            state.releaseTemporaries result
            instructions = [ valueInstructions..., castingInstructions..., new Assign(MemoryReference.from(expectedType, null, MemoryReference.RETURN), result) ]
        else # return;
            actualType = PRIMITIVE_TYPES.VOID

            if actualType isnt expectedType
                @compilationError 'NO_RETURN', "expected", expectedType.getSymbol(), "name", functionId

            instructions = []

        instructions.push new Return

        instructions.forEach((x) => x.locations = @locations)


        return {
            type: PRIMITIVE_TYPES.VOID,
            instructions
        }

    execute: (vm) ->
        { func, instruction, temporariesOffset } = vm.controlStack.pop()

        vm.pointers.temporaries = temporariesOffset
        vm.pointers.instruction = instruction

        vm.finished or= vm.func.id is MAIN_FUNCTION and vm.controlStack.length is 0

        vm.func = func
        vm.pointers.stack -= vm.func.stackSize
        vm.instructions = vm.func.instructions

    isReturn: yes
