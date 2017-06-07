{ Ast } = require './ast'
{ PRIMITIVE_TYPES, ensureType, EXPR_TYPES } = require './type'
{ BranchFalse, BranchTrue } = require './branch'
{ Assign } = require './assign'
{ IntLit } = require './literals'
Error = require '../error'
utils = require '../utils'
module.exports = @

# TODO: Pointers and arrays should only be allowed to perform + and - operations, and only with integrals (pointer is not integral)
# TODO: Also, when a pointer/array is within the operation, the returned value IS an lvalue
# TODO: Check if pointer has incomplete type, in that case operations cannot be performed

invalidOperands = (left, right) ->
    throw Error.INVALID_OPERANDS.complete("typel", left.type, "typer", right.type)

@BinaryOp = class BinaryOp extends Ast
    pointerCase: invalidOperands

    compile: (state) ->
        [ left, right ] = @children.map((x) -> x.compile(state))

        if left.type.isPointer or right.type.isPointer or left.type.isArray or right.type.isArray
            return @pointerCase(left, right, state)

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

        return { instructions, result, type, exprType: EXPR_TYPES.RVALUE }

    execute: (state) ->
        { memory } = state

        [ reference, value1, value2 ] = @children

        reference.write memory, @f(value1.read(memory), value2.read(memory), state)

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
    castType: (operandTypes) -> if PRIMITIVE_TYPES.DOUBLE in operandTypes then PRIMITIVE_TYPES.DOUBLE else PRIMITIVE_TYPES.INT


class MaybePointerArithmetic extends SimpleArithmetic
    pointerCase: (left, right, state) ->
        ref =
            if left.type.isPointer or left.type.isArray
                { pointer: left, left: 'pointer', nonPointer: right, right: 'nonPointer'}
            else
                { pointer: right, left: 'nonPointer', nonPointer: left, right: 'pointer'}

        unless ref.nonPointer.type.isIntegral
            invalidOperands(ref[ref.left], ref[ref.right])

        elementType = ref.pointer.type.getElementType()

        if elementType.isIncomplete
            throw Error.UNALLOWED_ARITHMETIC_INCOMPLETE_TYPE.complete("type", elementType)

        { bytes } = elementType

        ref.nonPointer = (new Mul({ compile: -> { type: PRIMITIVE_TYPES.INT, result: ref.nonPointer.result, instructions: ref.nonPointer.instructions } }, new IntLit(bytes))).compile(state)

        state.releaseTemporaries ref[ref.left].result, ref[ref.right].result

        type =
            if ref.pointer.type.isArray
                ref.pointer.type.getPointerType()
            else
                ref.pointer.type

        isConst = type.isValueConst

        result = state.getTemporary type

        instructions = [ ref[ref.left].instructions..., ref[ref.right].instructions..., new @constructor(result, ref[ref.left].result, ref[ref.right].result) ]

        { result, instructions, type, lvalueId: 'unknown', exprType: EXPR_TYPES.LVALUE, isConst }


@Add = class Add extends MaybePointerArithmetic
    f: (x, y) -> x+y


@Sub = class Sub extends MaybePointerArithmetic
    f: (x, y) -> x-y


@Mul = class Mul extends SimpleArithmetic
    f: (x, y) -> x*y

class IntDiv extends BinaryOp
    f: (x, y, state) ->
        state.executionError Error.DIVISION_BY_ZERO if y is 0
        x/y

class DoubleDiv extends BinaryOp
    f: (x, y) -> x/y

@Div = class Div extends SimpleArithmetic
    castType: (operandTypes) ->
        resultType = super operandTypes

        @constructor =
            switch resultType
                when PRIMITIVE_TYPES.INT then IntDiv
                when PRIMITIVE_TYPES.DOUBLE then DoubleDiv
                else assert false

        return resultType

@Mod = class Mod extends Arithmetic
    castType: ([ typeLeft, typeRight ]) ->
        unless typeLeft.isIntegral and typeRight.isIntegral
            throw Error.NON_INTEGRAL_MODULO

        PRIMITIVE_TYPES.INT

    f: (x, y, state) ->
        state.executionError Error.MODULO_BY_ZERO if y is 0
        x%y


class LazyOperator extends Ast
    compile: (state) ->

        left = @left().compile(state)
        { result: resultLeft, instructions: castingInstructionsLeft } = ensureType left.result, left.type, PRIMITIVE_TYPES.BOOL, state

        state.releaseTemporaries resultLeft

        right = @right().compile(state)
        { result: resultRight, instructions: castingInstructionsRight } = ensureType right.result, right.type, PRIMITIVE_TYPES.BOOL, state

        state.releaseTemporaries resultRight

        result = state.getTemporary PRIMITIVE_TYPES.BOOL

        rightInstructionsSize = right.instructions.length + castingInstructionsRight.length + 1

        # This assumes that castings have no side effects
        instructions = [ left.instructions..., castingInstructionsLeft..., new Assign(result, resultLeft), new @branch(resultLeft, rightInstructionsSize), right.instructions...,
            castingInstructionsRight..., new Assign(result, resultRight) ]

        return { instructions, result, type: PRIMITIVE_TYPES.BOOL, exprType: EXPR_TYPES.RVALUE }


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

        return { type: PRIMITIVE_TYPES.BOOL, results, instructions }

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

