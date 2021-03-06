{ Ast } = require './ast'
{ PRIMITIVE_TYPES, ensureType } = require './type'
{ Branch, BranchFalse } = require './branch'
{ BoolLit } = require './literals'
{ OpenScope, CloseScope } = require './debug-info'
{ countInstructions } = require '../utils'

module.exports = @

@For = class For extends Ast
    name: "For"
    compile: (state) ->
        [ init, condition, afterIteration, body ] = @children

        # Comprovar recursivament la inicialitzacio i el increment, comprovar/castejar que la condicio es un boolea
        # Comprovar recursivament el cos del for
        # Retorna void

        # TODO: Note that all parts of the for will possibly be null in the future, so this will have to be fixed

        state.openScope()

        if init isnt no
            { instructions: instructionsInit } = init.compile state
        else
            instructionsInit = []

        if condition isnt no
            { type: conditionType, instructions: conditionInstructions, result: conditionResult } = condition.compile state
        else
            conditionInstructions = []
            conditionType = PRIMITIVE_TYPES.BOOL
            conditionResult = new BoolLit 1

        { instructions: castingInstructions, result: castingResult } = ensureType conditionResult, conditionType, PRIMITIVE_TYPES.BOOL, state, this

        state.releaseTemporaries castingResult if castingResult?

        { instructions: bodyInstructions } = body.compile state

        if afterIteration isnt no
            { instructions: afterInstructions, result: afterResult } = afterIteration.compile state
        else
            afterInstructions = []

        state.releaseTemporaries afterResult if afterResult?

        state.closeScope()

        instructionsInit.forEach((x) -> x.locations = init.locations)
        topInstructions = [conditionInstructions..., castingInstructions...]
        topInstructions.forEach((x) -> x.locations = condition.locations)
        afterInstructions.forEach((x) -> x.locations = afterIteration.locations)

        afterInstructionCount = countInstructions afterInstructions
        bodyInstructionsCount = countInstructions bodyInstructions
        conditionInstructionsCount = countInstructions conditionInstructions
        castingInstructionsCount = countInstructions castingInstructions

        return {
            type: PRIMITIVE_TYPES.VOID
            instructions: [
                new OpenScope()
                instructionsInit...,
                topInstructions...,
                new BranchFalse(castingResult, bodyInstructionsCount + afterInstructionCount + 1)
                bodyInstructions...,
                afterInstructions...,
                new Branch(-(afterInstructionCount + bodyInstructionsCount + 1 + castingInstructionsCount + conditionInstructionsCount + 1))
                new CloseScope()
            ]
        }
