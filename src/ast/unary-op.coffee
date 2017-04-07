{ Ast } = require './ast'
{ TYPES, ensureType } = require './type'

module.exports = @

@UnaryOp = class UnaryOp extends Ast
    compile: (state) ->
        console.log "UnaryOp"
        
        [ value ] = @children

        operand = value.compile state

        { type, result: castingResult, instructions: castingInstructions } = @casting operand, state

        state.releaseTemporaries castingResult

        result = state.getTemporary type

        instructions = [ operand.instructions..., castingInstructions..., new @constructor(result, castingResult) ]

        return { instructions, type, result }

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
@Usub = class Usub extends Uarithmetic
@PreInc = class PreInc extends Uarithmetic
@PreDec = class PreDec extends Uarithmetic
@PostInc = class PostInc extends Uarithmetic
@PostDec = class PostDec extends Uarithmetic

@Not = class Not extends UnaryOp
    casting: (operand, state) ->
        { type: operandType, result: operandResult } = operand

        { result, instructions } = ensureType operandResult, operandType, TYPES.BOOL, state

        { type: TYPES.BOOL, result, instructions }
