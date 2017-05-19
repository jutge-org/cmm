{ Ast } = require './ast'
{ ensureType, PRIMITIVE_TYPES, EXPR_TYPES } = require './type'

module.exports = @

@Initializer = class Initializer extends Ast

@ArrayInitializer = class ArrayInitializer extends Initializer
    compile: (state) ->
        # TODO: Implement

        values = @children

        { exprType: EXPR_TYPES.RVALUE }
