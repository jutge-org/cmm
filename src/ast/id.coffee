{ Ast } = require './ast'
Error = require '../error'
{ EXPR_TYPES } = require './type'

module.exports = @

@Id = class Id extends Ast
    compile: (state) ->
        [ id ] = @children

        variable = state.getVariable id

        unless variable?
            throw Error.REF_VARIABLE_NOT_DEFINED.complete('name', id)

        return type: variable.type, result: variable.memoryReference, instructions: [], exprType: EXPR_TYPES.LVALUE, lvalueId: id