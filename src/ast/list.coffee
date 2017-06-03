{ Ast } = require './ast'

module.exports = @

@List = class List extends Ast
    compile: (state, args...) ->
        instructions = []
        for child in @children
            res = child.compile state, args...
            state.releaseTemporaries res.result if res.result?
            instructions = instructions.concat res.instructions


        { instructions }

@ScopedList = class ScopedList extends List
    compile: (state, args...) ->
        state.openScope()

        result = super state, args...

        state.closeScope()

        result