{ Ast } = require './ast'
{ TYPES, ensureType } = require './type'

module.exports = @

@UnaryOp = class UnaryOp extends Ast
    compile: (state) ->
        [ value ] = @children

        operand = value.compile state

        { type, result: castingResult, instructions: castingInstructions } = @casting operand, state

        state.releaseTemporaries castingResult

        result = state.getTemporary type

        instructions = [ operand.instructions..., castingInstructions..., new @constructor(result, castingResult) ]

        return { instructions, type, result }

    execute: ({ memory }) ->
        [ variable, value ] = @children

        variable.write memory, @f(value.read(memory))

class Uarithmetic extends UnaryOp
    casting: (operand, state) ->
        { type: operandType, result: operandResult } = operand

        unless operandType.isNumeric
            { result, instructions } = ensureType operandResult, operandType, TYPES.INT, state
            type = TYPES.INT
        else
            type = operandType
            result = operandResult
            instructions = []

        { type, result, instructions }

@Uadd = class Uadd extends Uarithmetic
    f: (x) -> +x
@Usub = class Usub extends Uarithmetic
    f: (x) -> -x


class PreOp extends Uarithmetic
    execute: ({ memory }) ->
        [ dest, value ] = @children
        result = value.read(memory) + @incr
        value.write(memory, result)
        dest.write(memory, result)

@PreInc = class PreInc extends PreOp
    incr: 1
@PreDec = class PreDec extends PreOp
    incr: -1


class PostOp extends Uarithmetic
    execute: ({ memory }) ->
        [ destRef, valueRef ] = @children
        value = valueRef.read memory
        valueRef.write memory, value + @incr
        destRef.write memory, value

@PostInc = class PostInc extends PostOp
    incr: 1
@PostDec = class PostDec extends Uarithmetic
    incr: -1

@Not = class Not extends UnaryOp
    casting: (operand, state) ->
        { type: operandType, result: operandResult } = operand

        { result, instructions } = ensureType operandResult, operandType, TYPES.BOOL, state

        { type: TYPES.BOOL, result, instructions }

    f: (x) -> not x
