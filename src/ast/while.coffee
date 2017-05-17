{ Ast } = require './ast'
{ BASIC_TYPES, ensureType } = require './type'
utils = require '../utils'
{ Branch, BranchFalse } = require './branch'

module.exports = @

@While = class While extends Ast
    compile: (state) ->
        [ conditionAst, body ] = @children

        # Comprovar/castejar que la condicio es un boolea
        # Comprovar recursivament el cos del while
        # Retorna void

        { type: conditionType, instructions: conditionInstructions, result: conditionResult } = conditionAst.compile state

        { result: castingResult, instructions: castingInstructions } = ensureType conditionResult, conditionType, BASIC_TYPES.BOOL, state

        state.releaseTemporaries castingResult

        state.openScope()

        { instructions: bodyInstructions } = body.compile state

        state.closeScope()

        topInstructions = [conditionInstructions..., castingInstructions...]
        topInstructions.forEach((x) -> x.locations = conditionAst.locations)

        return {
             type: BASIC_TYPES.VOID,
             instructions: [
                 topInstructions...
                 new BranchFalse(castingResult, bodyInstructions.length + 1),
                 bodyInstructions...,
                 # The first +1 accounts for the branchfalse after the condition check.
                 # The second one is to account for the increase to the next instruction that is always made
                 new Branch(-(bodyInstructions.length + 1 + topInstructions.length + 1))
             ]
        }