{ Ast } = require './ast'
{ IO } = require '../runtime/io'

@Write = class Write extends Ast
    execute: ({ memory, io }) ->
        [ idReference ] = @children
        value = idReference.read memory
        io.output IO.STDOUT, idReference.getType().castings.COUT(value)