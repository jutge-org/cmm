{ Ast } = require './ast'
{ ensureType, PRIMITIVE_TYPES, EXPR_TYPES, Pointer } = require './type'
{ PointerMemoryReference, Leal } = require './memory-reference'
Error = require '../error'

module.exports = @

@ArraySubscript = class ArraySubscript extends Ast
    compile: (state) ->
        [ variable, index ] = @children

        { type, lvalueId, result: variableResult, instructions: variableInstructions } = variable.compile state

        { result: indexResult, instructions: indexInstructions, type: indexType } = index.compile state

        unless type.isArray or type.isPointer
            throw Error.INVALID_ARRAY_SUBSCRIPT.complete("type", type.getSymbol(), "typeSubscript", indexType.getSymbol())

        { instructions: indexCastInstructions, result: indexCastResult } = ensureType indexResult, indexType, PRIMITIVE_TYPES.INT, state

        state.releaseTemporaries indexCastResult

        state.releaseTemporaries variableResult

        type = type.getElementType()

        instructions = [ variableInstructions..., indexInstructions..., indexCastInstructions... ]

        if type.isArray
            result = state.getTemporary new Pointer(type.getElementType())

            instructions.push(new Leal(result, variableResult, indexCastResult, type.bytes))
        else
            result = new PointerMemoryReference(type, variableResult, indexCastResult)

        {
            exprType: EXPR_TYPES.LVALUE, lvalueId,
            instructions,
            result,
            type
        }





