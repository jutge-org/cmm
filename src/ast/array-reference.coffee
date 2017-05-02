{ Ast } = require './ast'

module.exports = @

@ArrayReference = class ArrayReference extends Ast
    compile: (state) ->