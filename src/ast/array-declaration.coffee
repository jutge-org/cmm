{ Ast } = require './ast'

module.exports = @

@ArrayDeclaration = class ArrayDeclaration extends Ast
    compile: (state) ->