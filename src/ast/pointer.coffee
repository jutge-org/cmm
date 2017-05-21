
{ Ast } = require './ast'

module.exports = @

@Pointer = class Pointer extends Ast
    compile: (state) ->

@NullPtr = class NullPtr extends Ast
    compile: (state) ->