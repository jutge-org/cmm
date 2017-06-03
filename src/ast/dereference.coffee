{ Ast } = require './ast'
{ PointerMemoryReference } = require './memory-reference'
{ IntLit } = require './literals'
{ EXPR_TYPES } = require './type'

module.exports = @

@Dereference = class Dereference extends Ast
    compile: (state) ->
        [ valueAst ] = @children

        { type, result: valueResult, instructions: valueInstructions } =
            valueAst.compile state

        unless type.isPointer or type.isArray
            throw INVALID_DEREFERENCE_TYPE.complete("type", type.getSymbol())

        state.releaseTemporaries valueResult

        isConst = type.isValueConst

        type = type.getElementType()

        { type, result: new PointerMemoryReference(type, valueResult, new IntLit(0)), exprType: EXPR_TYPES.LVALUE, lvalueId: 'unknown', isConst, instructions: valueInstructions }
        # TODO: Fix this lvalueId: unknown, should construct the lvalueId with all successive operations applied to it as we go up
        #       lvalueId is used when displaying errors to the user, for him to be able to identify which variable it is related to