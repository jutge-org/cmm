{ Ast } = require './ast'
{ PRIMITIVE_TYPES, ensureType } = require './type'
{ Branch, BranchFalse } = require './branch'
{ OpenScope, CloseScope } = require './debug-info'
{ countInstructions } = require '../utils'

module.exports = @

@IfThen = class IfThen extends Ast
    name: "IfThen"
    compile: (state) ->
        [ conditionAst, thenBody ] = @children

        # Comprovar/castejar que la condicio es un boolea
        # Comprovar recursivament el cos del then
        # Retorna void

        { type: conditionType, result: conditionResult, instructions: conditionInstructions } = conditionAst.compile state

        { instructions: castingInstructions, result: castingResult } = ensureType conditionResult, conditionType, PRIMITIVE_TYPES.BOOL, state, conditionAst

        state.releaseTemporaries castingResult

        state.openScope()

        { instructions: thenInstructions } = thenBody.compile state

        state.closeScope()

        branch = new BranchFalse(castingResult, countInstructions(thenInstructions))

        topInstructions = [ conditionInstructions..., castingInstructions...]
        topInstructions.forEach((x) => x.locations = conditionAst.locations)

        instructions = [ topInstructions..., branch, new OpenScope(), thenInstructions..., new CloseScope() ]

        return { type: PRIMITIVE_TYPES.VOID, branch, instructions }

@IfThenElse = class IfThenElse extends @IfThen
    name: "IfThenElse"
    compile: (state) ->
        [ _, _, elseBody ] = @children

        { type, instructions, branch } = super state

        [ _, branchOffset ] = branch.children

        branch.setChild 1, (branchOffset + 1) # To account for the after-then branch to jump over the else

        state.openScope()

        { instructions: elseInstructions } = elseBody.compile state

        state.closeScope()

        return {
            type,
            instructions: [
                instructions...,
                new Branch(countInstructions(elseInstructions)),
                new OpenScope(),
                elseInstructions...,
                new CloseScope() ]
        }
