{ Ast } = require './ast'
{ ensureType, BASIC_TYPES } = require './type'

module.exports = @

@Initializer = class Initializer extends Ast

@ArrayInitializer = class ArrayInitializer extends Initializer
    compile: (state) ->
        # TODO: Implement

        values = @children
