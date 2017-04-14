{ Ast } = require './ast'
Error = require '../error'

module.exports = @

@Id = class Id extends Ast
    compile: (state) ->
        [ id ] = @children

        variable = state.getVariable id

        unless variable?
            throw Error.GET_VARIABLE_NOT_DEFINED.complete('name', id)

        return type: variable.type, result: variable.memoryReference, instructions: []