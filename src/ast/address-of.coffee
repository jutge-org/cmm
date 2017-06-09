{ Ast } = require './ast'
{ EXPR_TYPES, PRIMITIVE_TYPES, Pointer } = require './type'
{ Assign } = require './assign'

module.exports = @

@AddressOf = class AddressOf extends Ast
    compile: (state) ->
        [ valueAst ] = @children

        { exprType, type: valueType, result: valueResult, instructions: valueInstructions, isConst } = valueAst.compile state

        if valueType is PRIMITIVE_TYPES.STRING
            @compilationError 'STRING_ADDRESSING'

        unless valueType.isReferenceable
            @compilationError 'ASSIGNABLE_ADDRESSING'

        if exprType isnt EXPR_TYPES.LVALUE
            @compilationError 'LVALUE_ADDRESSING'

        state.releaseTemporaries valueResult

        type = new Pointer valueType, { isValueConst: isConst }

        result = state.getTemporary type

        if valueType.isArray
            instructions = [ valueInstructions..., new Assign(result, valueResult) ]
        else
            instructions = [ valueInstructions..., new AddressOf(result, valueResult) ]

        { instructions, result, type, exprType: EXPR_TYPES.RVALUE }


    execute: ({ memory }) ->
        [ destReference, reference ] = @children

        destReference.write(memory, reference.getAddress(memory))

