{ Ast } = require './ast'
Error = require '../error'
{ EXPR_TYPES, Pointer } = require './type'
{ GetAddress } = require './memory-reference'

module.exports = @

@Id = class Id extends Ast
    compile: (state) ->
        [ id ] = @children

        variable = state.getVariable id

        unless variable?
            throw Error.REF_VARIABLE_NOT_DEFINED.complete('name', id)

        if variable.type.isArray
            result = state.getTemporary new Pointer(variable.type.getElementType())
            instructions = [ new GetAddress result, variable.memoryReference ]
        else
            result = variable.memoryReference
            instructions = []

        return { type: variable.type, result, instructions, exprType: EXPR_TYPES.LVALUE, lvalueId: id }
