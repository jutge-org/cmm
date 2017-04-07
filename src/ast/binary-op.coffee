{ Ast } = require './ast'
{ TYPES, ensureType } = require './type'
Error = require '../error'
utils = require '../utils'
module.exports = @

@BinaryOp = class BinaryOp extends Ast
    compile: (state) ->
        [ left, right ] = @children.map((x) -> x.compile(state))

        operands = [ left, right ]

        { type, results, instructions: castingInstructions } = @casting operands, state

        unless left.result is results[0]
            state.releaseTemporaries left.result
        unless right.result is results[1]
            state.releaseTemporaries right.result

        state.releaseTemporaries(results...)

        result = state.getTemporary type

        [ leftResult, rightResult ] = results

        # This assumes that castings have no side effects
        instructions = [ left.instructions..., right.instructions...,
                         castingInstructions..., new @constructor(result, leftResult, rightResult) ]

        return { instructions, result, type }

class Arithmetic extends BinaryOp
    casting: (operands, state) ->
        expectedType = @castType operands.map((x) -> x.type)

        results = []
        instructions = []

        for { type: operandType, result: operandResult }, i in operands
            { result: castingResult, instructions: castingInstructions } =
                ensureType operandResult, operandType, expectedType, state, { releaseReference: no }

            instructions = instructions.concat(castingInstructions)
            results.push castingResult

        return { type: expectedType, results, instructions }

class SimpleArithmetic extends Arithmetic
    castType: (operandTypes) -> if TYPES.DOUBLE in operandTypes then TYPES.DOUBLE else TYPES.INT

@Add = class Add extends SimpleArithmetic
@Sub = class Sub extends SimpleArithmetic
@Mul = class Mul extends SimpleArithmetic

# The div interpretation is implemented in the two following classes. The Div
# class is only for the compilation stage and 'mutates' to one of them
# depending on the operand types
class IntDiv extends Ast
class DoubleDiv extends Ast
@Div = class Div extends SimpleArithmetic
    castType: (operandTypes) ->
        resultType = super operandTypes

        @constructor =
            switch resultType
                when TYPES.INT then IntDiv
                when TYPES.DOUBLE then DoubleDiv
                else assert false

        return resultType

@Mod = class Mod extends Arithmetic
    castType: ([ typeLeft, typeRight ]) ->
        unless typeLeft.isIntegral and typeRight.isIntegral
            throw Error.NON_INTEGRAL_MODULO

        TYPES.INT



class LogicArithmetic extends Arithmetic
    castType: -> TYPES.BOOL

@And = class And extends LogicArithmetic
@Or = class Or extends LogicArithmetic



class Comparison extends BinaryOp
    casting: (operands, state) ->
        [ typeLeft, typeRight ] = actualTypes = operands.map((x) -> x.type)

        results = []
        instructions = []
        if typeLeft isnt typeRight
            for { type: operandType, result: operandResult } in operands
                { result: castingResult, instructions: castingInstructions } =
                    ensureType operandResult, operandType, utils.max(actualTypes, (t) -> t.size).arg, state, { releaseReference: no }

                instructions = instructions.concat(castingInstructions)
                results.push castingResult
        else
            results = operands.map((x) -> x.result)
            instructions = []

        return { type: TYPES.BOOL, results, instructions }

@Lt = class Lt extends Comparison
@Lte = class Lte extends Comparison
@Gt = class Gt extends Comparison
@Gte = class Gte extends Comparison
@Eq = class Eq extends Comparison
@Neq = class Neq extends Comparison

