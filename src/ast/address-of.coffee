Error = require '../error'
{ Ast } = require './ast'
{ EXPR_TYPES, PRIMITIVE_TYPES, Pointer } = require './type'

module.exports = @

@AddressOf = class AddressOf extends Ast
    compile: (state) ->
        [ valueAst ] = @children

        { exprType, type, result: valueResult, instructions: valueInstructions, isConst } = valueAst.compile state

        if type is PRIMITIVE_TYPES.STRING
            throw Error.STRING_ADDRESSING

        unless type.isAssignable
            throw Error.ASSIGNABLE_ADDRESSING

        if exprType isnt EXPR_TYPES.LVALUE
            throw Error.LVALUE_ADDRESSING

        type = new Pointer type, { isValueConst: isConst }

        result = state.getTemporary type

        instructions = [ valueInstructions..., new AddressOf result, valueResult ]

        { instructions, result, type, exprType: EXPR_TYPES.RVALUE }


    execute: ({ memory }) ->
        [ destReference, reference ] = @children

        destReference.write(memory, reference.getAddress())

