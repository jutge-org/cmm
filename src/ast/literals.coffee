assert = require 'assert'

{ Ast } = require './ast'

{ TYPES } = require './type'
{ T0 } = require './memory-reference'
{ Assign } = require './assign'

module.exports = @

# TODO: This parsings should return standard c-- errors
# TODO: Check they match the expected behaviour as in c++ 0.0f, 0.0L?

@Literal = class Literal extends Ast
    compile: (state) ->
        console.log "Literal"

        assert @parse, "Literal did not define parse method"
        assert @type, "Literal did not define type"

        [ s ] = @children

        @setChild 0, @type.tipify(@parse s)

        reference = state.getTemporary @type

        { @type, instructions: [new Assign reference, this], result: reference }

    getValue: -> @getChild 0

@DoubleLit = class DoubleLit extends Literal
    parse: parseFloat
    type: TYPES.DOUBLE

@IntLit = class IntLit extends Literal
    parse: parseInt
    type: TYPES.INT

@StringLit = class StringLit extends Literal
    parse: (s) -> JSON.parse("{ \"s\": #{s} }").s
    type: TYPES.STRING

@CharLit = class CharLit extends Literal
    parse: (s) -> JSON.parse("{ \"s\": \"#{s[1...-1]}\" }").s.charCodeAt(0)
    type: TYPES.CHAR

@BoolLit = class BoolLit extends Literal
    parse: (s) -> s is "true"
    type: TYPES.BOOL