{ Ast } = require './ast'
{ TYPES, ensureType } = require './type'
{ Branch, BranchFalse } = require './branch'

module.exports = @

@IfThen = class IfThen extends Ast
    compile: (state) ->
        console.log "IfThen"

        [ conditionAst, thenBody ] = @children

        # Comprovar/castejar que la condicio es un boolea
        # Comprovar recursivament el cos del then
        # Retorna void

        { type: conditionType, result: conditionResult, instructions: conditionInstructions } = conditionAst.compile state

        { instructions: castingInstructions, result: castingResult } = ensureType conditionResult, conditionType, TYPES.BOOL, state

        state.releaseTemporaries castingResult

        state.openScope()

        { instructions: thenInstructions } = thenBody.compile state

        state.closeScope()

        branch = new BranchFalse(castingResult, thenInstructions.length)

        return { type: TYPES.VOID, branch, instructions: [ conditionInstructions..., castingInstructions...,
                                                 branch, thenInstructions... ] }

@IfThenElse = class IfThenElse extends @IfThen
    compile: (state) ->
        console.log "IfThenElse"

        [ _, _, elseBody ] = @children

        { type, instructions, branch } = super state

        [ _, branchOffset ] = branch.children

        branch.setChild 1, (branchOffset + 1) # To account for the after-then branch to jump over the else

        state.openScope()

        { instructions: elseInstructions } = elseBody.compile state

        state.closeScope()

        return { type, instructions: [ instructions..., new Branch(elseInstructions.length), elseInstructions... ] }