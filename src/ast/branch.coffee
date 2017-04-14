{ Ast } = require './ast'

module.exports = @

@Branch = class Branch extends Ast
    execute: (state) ->
        [ jumpOffset ] = @children
        state.pointers.instruction += jumpOffset

        yes

@BranchFalse = class BranchFalse extends Ast
    execute: (state) ->
        [ conditionReference, jumpOffset ] = @children
        state.pointers.instruction += jumpOffset unless conditionReference.read(state.memory)

        yes

@BranchTrue = class BranchTrue extends Ast
    execute: (state) ->
        [ conditionReference, jumpOffset ] = @children
        state.pointers.instruction += jumpOffset if conditionReference.read(state.memory)

        yes