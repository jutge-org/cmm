Error = require '../error'
{ Ast } = require './ast'
{ BASIC_TYPES, ensureType, EXPR_TYPES } = require './type'

module.exports = @

@UnaryOp = class UnaryOp extends Ast
    compile: (state) ->
        [ value ] = @children

        operand = value.compile state

        { type, result: castingResult, instructions: castingInstructions } = @casting operand, state

        state.releaseTemporaries castingResult

        result = state.getTemporary type

        instructions = [ operand.instructions..., castingInstructions..., new @constructor(result, castingResult) ]

        return { instructions, type, result, exprType: EXPR_TYPES.RVALUE }

    execute: ({ memory }) ->
        [ variable, value ] = @children

        variable.write memory, @f(value.read(memory))

class Uarithmetic extends UnaryOp
    casting: (operand, state) ->
        { type: operandType, result: operandResult } = operand

        unless operandType.isNumeric
            { result, instructions } = ensureType operandResult, operandType, BASIC_TYPES.INT, state
            type = BASIC_TYPES.INT
        else
            type = operandType
            result = operandResult
            instructions = []

        { type, result, instructions }

@Uadd = class Uadd extends Uarithmetic
    f: (x) -> +x
@Usub = class Usub extends Uarithmetic
    f: (x) -> -x


@Not = class Not extends UnaryOp
    casting: (operand, state) ->
        { type: operandType, result: operandResult } = operand

        { result, instructions } = ensureType operandResult, operandType, BASIC_TYPES.BOOL, state

        { type: BASIC_TYPES.BOOL, result, instructions }

    f: (x) -> not x
