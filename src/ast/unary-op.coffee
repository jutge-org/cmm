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

        yes

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

@PreInc = class PreInc extends Uarithmetic
    execute: ({ memory }) ->
        [ dest, value ] = @children
        result = value.read(memory) + 1
        value.write(memory, result)
        dest.write(memory, result)

        yes

@PreDec = class PreDec extends Uarithmetic
    execute: ({ memory }) ->
        [ dest, value ] = @children
        result = value.read(memory) - 1
        value.write(memory, result)
        dest.write(memory, result)

        yes

@PostInc = class PostInc extends Uarithmetic
    execute: ({ memory }) ->
        [ destRef, valueRef ] = @children
        value = valueRef.read memory
        destRef.write memory, value
        valueRef.write memory, value + 1

        yes
@PostDec = class PostDec extends Uarithmetic
    execute: ({ memory }) ->
        [ destRef, valueRef ] = @children
        value = valueRef.read memory
        destRef.write memory, value
        valueRef.write memory, value - 1

        yes

@Not = class Not extends UnaryOp
    casting: (operand, state) ->
        { type: operandType, result: operandResult } = operand

        { result, instructions } = ensureType operandResult, operandType, TYPES.BOOL, state

        { type: TYPES.BOOL, result, instructions }

    f: (x) -> not x
