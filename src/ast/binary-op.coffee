{ Ast } = require './ast'
{ TYPES, ensureType } = require './type'
{ BranchFalse, BranchTrue } = require './branch'
{ Assign } = require './assign'
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

    execute: ({ memory }) ->
        [ reference, value1, value2 ] = @children

        reference.write memory, @f(value1.read(memory), value2.read(memory))

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
    f: (x, y) -> x+y
@Sub = class Sub extends SimpleArithmetic
    f: (x, y) -> x-y
@Mul = class Mul extends SimpleArithmetic
    f: (x, y) -> x*y

class IntDiv extends BinaryOp
    f: (x, y) ->
        throw Error.DIVISION_BY_ZERO if y is 0
        x/y

class DoubleDiv extends BinaryOp
    f: (x, y) -> x/y

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

    f: (x, y) ->
        throw Error.MODULO_BY_ZERO if y is 0
        x%y



class LogicArithmetic extends Arithmetic
    castType: -> TYPES.BOOL


class LazyOperator extends Ast
    compile: (state) ->

        left = @left().compile(state)
        { result: resultLeft, instructions: castingInstructionsLeft } = ensureType left.result, left.type, TYPES.BOOL, state

        state.releaseTemporaries resultLeft

        right = @right().compile(state)
        { result: resultRight, instructions: castingInstructionsRight } = ensureType right.result, right.type, TYPES.BOOL, state

        state.releaseTemporaries resultRight

        result = state.getTemporary TYPES.BOOL

        rightInstructionsSize = right.instructions.length + castingInstructionsRight.length + 1

        # This assumes that castings have no side effects
        instructions = [ left.instructions..., castingInstructionsLeft..., new Assign(result, resultLeft), new @branch(resultLeft, rightInstructionsSize), right.instructions...,
            castingInstructionsRight..., new Assign(result, resultRight) ]

        return { instructions, result, type: TYPES.BOOL }


@And = class And extends LazyOperator
    branch: BranchFalse
@Or = class Or extends LazyOperator
    branch: BranchTrue


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
    f: (x, y) -> x < y
@Lte = class Lte extends Comparison
    f: (x, y) -> x <= y
@Gt = class Gt extends Comparison
    f: (x, y) -> x > y
@Gte = class Gte extends Comparison
    f: (x, y) -> x >= y
@Eq = class Eq extends Comparison
    f: (x, y) -> x is y
@Neq = class Neq extends Comparison
    f: (x, y) -> x isnt y
