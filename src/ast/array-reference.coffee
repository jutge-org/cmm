{ Ast } = require './ast'
{ ensureType, BASIC_TYPES, EXPR_TYPES } = require './type'

module.exports = @

@ArrayReference = class ArrayReference extends Ast
    compile: (state) ->
        [ variable, index ] = @children

        { children: [ id ] } = variable

        { result: indexResult, instructions: indexInstructions, type: indexType } = index.compile state

        { instructions: indexCastInstructions, result: indexCastResult } = ensureType indexResult, indexType, BASIC_TYPES.INT, state

        state.releaseTemporaries indexCastResult


        { exprType: TYPES.LVALUE, lvalueId: id }
        # TODO: Finish implementation





