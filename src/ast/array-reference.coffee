{ Ast } = require './ast'
{ ensureType, BASIC_TYPES } = require './type'

module.exports = @

@ArrayReference = class ArrayReference extends Ast
    compile: (state) ->
        [ variable, index ] = @children

        { result: indexResult, instructions: indexInstructions, type: indexType } = index.compile state

        { instructions: indexCastInstructions, result: indexCastResult } = ensureType indexResult, indexType, BASIC_TYPES.INT, state

        state.releaseTemporaries indexCastResult

        # TODO: Finish implementation





