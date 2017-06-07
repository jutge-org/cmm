{ Ast } = require './ast'
Error = require '../error'
{ EXPR_TYPES, Pointer } = require './type'
{ AddressOf } = require './address-of'

module.exports = @

@Id = class Id extends Ast
    compile: (state) ->
        [ id ] = @children

        variable = state.getVariable id

        unless variable?
            throw Error.REF_VARIABLE_NOT_DEFINED.complete('name', id)

        if variable.type.isArray
            result = state.getTemporary variable.type.getPointerType()
            instructions = [ new AddressOf result, variable.memoryReference ]
        else
            result = variable.memoryReference
            instructions = []

        return { type: variable.type, result, instructions, exprType: EXPR_TYPES.LVALUE, lvalueId: id, isConst: variable.specifiers?.const }
