{ Ast } = require './ast'
{ PRIMITIVE_TYPES, ensureType } = require './type'
{ Write } = require './write'
Error = require '../error'

module.exports = @

@Cout = class Cout extends Ast
    compile: (state) ->
        instructions = []

        for value in @children
            { result, instructions: valueInstructions, type } = value.compile state

            unless type.canCastTo(PRIMITIVE_TYPES.COUT)
                throw Error.CANNOT_COUT_TYPE.complete("type", type.getSymbol())

            state.releaseTemporaries result

            instructions = instructions.concat valueInstructions
            instructions.push new Write result

        instructions.forEach((x) => x.locations = @locations)

        return { type: PRIMITIVE_TYPES.VOID, instructions }