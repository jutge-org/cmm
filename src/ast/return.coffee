assert = require 'assert'

{ Ast } = require './ast'
{ TYPES, ensureType } = require './type'
{ Assign } = require './assign'
{ ReturnReference } = require './memory-reference'

module.exports = @

@Return = class Return extends Ast
    compile: (state) ->
        console.log "Return"

        [ value ] = @children

        # Comprovar/castejar que retorna el mateix tipus que el de la funció en la que estem
        # Si la funció en la que estem retorna void sa danar al tanto
        # Retorna void

        { functionId } = state

        func = state.getVariable functionId

        assert func?

        { returnType: expectedType } = func

        if value? # return (something);
            { type: actualType, instructions: valueInstructions, result: valueResult } = value.compile state
            { result, instructions: castingInstructions } = ensureType valueResult, actualType, expectedType, state   
            state.releaseTemporaries result
            instructions = [ valueInstructions..., castingInstructions..., new Assign(new ReturnReference(expectedType), result) ]
        else # return;i
            actualType = TYPES.VOID
            instructions = []

        instructions.push new Return

        return {
            type: TYPES.VOID,
            instructions
        }