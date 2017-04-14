{ Ast } = require './ast'
{ TYPES } = require './type'
{ Write } = require './write'

module.exports = @

@Cout = class Cout extends Ast
    compile: (state) ->
        # Comprovar/castejar que tots els fills siguin strings
        # Retorna void

        instructions = []

        for value in @children
            { type, result, instructions: valueInstructions } = value.compile state
            state.releaseTemporaries result
            instructions = instructions.concat valueInstructions
            instructions.push new Write result

        return { type: TYPES.VOID, instructions }