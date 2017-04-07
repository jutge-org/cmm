{ Ast } = require './ast'
{ TYPES, ensureType } = require './type'
utils = require '../utils'
{ Branch, BranchFalse } = require './branch'

module.exports = @

@For = class For extends Ast
    compile: (state) ->
        console.log "For"

        [ init, condition, afterIteration, body ] = @children

        # Comprovar recursivament la inicialitzacio i el increment, comprovar/castejar que la condicio es un boolea
        # Comprovar recursivament el cos del for
        # Retorna void

        # TODO: Note that all parts of the for will possibly be null in the future, so this will have to be fixed

        state.openScope()

        { instructions: instructionsInit } = init.compile state

        { type: conditionType, instructions: conditionInstructions, result: conditionResult } = condition.compile state

        { instructions: castingInstructions, result: castingResult } = ensureType conditionResult, conditionType, TYPES.BOOL, state

        state.releaseTemporaries castingResult if castingResult?

        { instructions: bodyInstructions } = body.compile state

        { instructions: afterInstructions, result: afterResult } = afterIteration.compile state

        state.releaseTemporaries afterResult if afterResult?

        state.closeScope()

        return {
            type: TYPES.VOID
            instructions: [
                instructionsInit...,
                conditionInstructions..., castingInstructions...,
                new BranchFalse(castingResult, bodyInstructions.length + afterInstructions.length + 1)
                bodyInstructions...,
                afterInstructions...,
                new Branch(-(afterInstructions.length + bodyInstructions.length + 1 + castingInstructions.length + conditionInstructions.length + 1))
            ]
        }



#return { type, variable, instructions }