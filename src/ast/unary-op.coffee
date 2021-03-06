{ Ast } = require './ast'
{ PRIMITIVE_TYPES, ensureType, EXPR_TYPES } = require './type'

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

@Uadd = class Uadd extends UnaryOp
    name: "Uadd"
    casting: (operand, state) ->
        { type: operandType, result: operandResult } = operand

        unless operandType.isNumeric or operandType.isPointer or operandType.isArray
            { result, instructions } = ensureType operandResult, operandType, PRIMITIVE_TYPES.INT, state, this
            type = PRIMITIVE_TYPES.INT
        else
            type = operandType
            result = operandResult
            instructions = []

        { type, result, instructions }

    f: (x) -> +x


@Usub = class Usub extends UnaryOp
    name: "Usub"
    casting: (operand, state) ->
        { type: operandType, result: operandResult } = operand

        if operandType.isPointer or operandType.isArray
            @compilationError 'WRONG_ARGUMENT_UNARY_MINUS', 'type', operandType.getSymbol()

        unless operandType.isNumeric
            { result, instructions } = ensureType operandResult, operandType, PRIMITIVE_TYPES.INT, state, this
            type = PRIMITIVE_TYPES.INT
        else
            type = operandType
            result = operandResult
            instructions = []

        { type, result, instructions }

    f: (x) -> -x


@Not = class Not extends UnaryOp
    name: "Not"
    casting: (operand, state) ->
        { type: operandType, result: operandResult } = operand

        { result, instructions } = ensureType operandResult, operandType, PRIMITIVE_TYPES.BOOL, state, this

        { type: PRIMITIVE_TYPES.BOOL, result, instructions }

    f: (x) -> not x
