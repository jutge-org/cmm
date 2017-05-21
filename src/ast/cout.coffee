{ Ast } = require './ast'
{ PRIMITIVE_TYPES } = require './type'
{ Write } = require './write'

module.exports = @

@Cout = class Cout extends Ast
    compile: (state) ->
        instructions = []

        for value in @children
            { result, instructions: valueInstructions } = value.compile state

            state.releaseTemporaries result
            instructions = instructions.concat valueInstructions
            instructions.push new Write result

        instructions.forEach((x) => x.locations = @locations)

        return { type: PRIMITIVE_TYPES.VOID, instructions }