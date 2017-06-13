{ Ast } = require './ast'
{ OpenScope, CloseScope } = require './debug-info'

module.exports = @

@List = class List extends Ast
    name: "List"
    compile: (state, args...) ->
        instructions = []
        for child in @children
            res = child.compile state, args...
            state.releaseTemporaries res.result if res.result?
            instructions = instructions.concat res.instructions


        { instructions }

@ScopedList = class ScopedList extends List
    name: "ScopedList"
    compile: (state, args...) ->
        state.openScope()

        result = super state, args...

        state.closeScope()

        result.instructions = [ new OpenScope, result.instructions..., new CloseScope ]

        result
