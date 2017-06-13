{ Ast } = require './ast'
{ PRIMITIVE_TYPES, ensureType } = require './type'
{ countInstructions } = require '../utils'
{ Branch, BranchFalse } = require './branch'
{ OpenScope, CloseScope } = require './debug-info'

module.exports = @

@While = class While extends Ast
    name: "While"
    compile: (state) ->
        [ conditionAst, body ] = @children

        # Comprovar/castejar que la condicio es un boolea
        # Comprovar recursivament el cos del while
        # Retorna void

        { type: conditionType, instructions: conditionInstructions, result: conditionResult } = conditionAst.compile state

        { result: castingResult, instructions: castingInstructions } = ensureType conditionResult, conditionType, PRIMITIVE_TYPES.BOOL, state, this

        state.releaseTemporaries castingResult

        state.openScope()

        { instructions: bodyInstructions } = body.compile state

        state.closeScope()

        topInstructions = [conditionInstructions..., castingInstructions...]
        topInstructions.forEach((x) -> x.locations = conditionAst.locations)

        bodyInstructionsCount = countInstructions bodyInstructions
        topInstructionsCount = countInstructions topInstructions

        return {
             type: PRIMITIVE_TYPES.VOID,
             instructions: [
                 topInstructions...
                 new BranchFalse(castingResult, bodyInstructionsCount + 1),
                 new OpenScope()
                 bodyInstructions...,
                 # The first +1 accounts for the branchfalse after the condition check.
                 # The second one is to account for the increase to the next instruction that is always made
                 new Branch(-(bodyInstructionsCount + 1 + topInstructionsCount + 1))
                 new CloseScope()
             ]
        }
