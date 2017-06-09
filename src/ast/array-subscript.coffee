{ Ast } = require './ast'
{ ensureType, PRIMITIVE_TYPES, EXPR_TYPES, Pointer } = require './type'
{ PointerMemoryReference, Leal } = require './memory-reference'
{ compilationError } = require '../messages'

module.exports = @

@ArraySubscript = class ArraySubscript extends Ast
    compile: (state) ->
        [ variable, index ] = @children

        { type, lvalueId, result: variableResult, instructions: variableInstructions } = variable.compile state

        { result: indexResult, instructions: indexInstructions, type: indexType } = index.compile state

        unless (type.isArray or type.isPointer) and indexType.isIntegral
            compilationError 'INVALID_ARRAY_SUBSCRIPT', "type", type.getSymbol(), "typeSubscript", indexType.getSymbol()

        { instructions: indexCastInstructions, result: indexCastResult } = ensureType indexResult, indexType, PRIMITIVE_TYPES.INT, state

        state.releaseTemporaries indexCastResult

        isConst = type.isValueConst

        type = type.getElementType()

        instructions = [ variableInstructions..., indexInstructions..., indexCastInstructions... ]

        if type.isArray
            state.releaseTemporaries variableResult

            result = state.getTemporary new Pointer(type.getElementType())

            instructions.push(new Leal(result, variableResult, indexCastResult, type.bytes))
        else
            result = new PointerMemoryReference(type, variableResult, indexCastResult)

        {
            exprType: EXPR_TYPES.LVALUE,
            lvalueId,
            instructions,
            result,
            type,
            isConst
        }





