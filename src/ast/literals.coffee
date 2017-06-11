assert = require 'assert'

{ Ast } = require './ast'

{ PRIMITIVE_TYPES, EXPR_TYPES, Pointer } = require './type'
{ T0 } = require './memory-reference'
{ Assign } = require './assign'

module.exports = @

# TODO: This parsings should return standard c-- errors
# TODO: Check they match the expected behaviour as in c++ 0.0f, 0.0L?

@Literal = class Literal extends Ast
    compile: (state) ->
        assert @parse, "Literal did not define parse method"
        assert @type, "Literal did not define type"

        [ s ] = @children

        @setChild 0, @type.tipify(@parse s)

        { @type, instructions: [], result: this, exprType: EXPR_TYPES.RVALUE, staticValue: @child() }

    read: -> @child()

    getType: -> @type

@DoubleLit = class DoubleLit extends Literal
    name: "DoubleLit"
    parse: parseFloat
    type: PRIMITIVE_TYPES.DOUBLE

@IntLit = class IntLit extends Literal
    name: "IntLit"
    parse: parseInt
    type: PRIMITIVE_TYPES.INT

@StringLit = class StringLit extends Literal # Should only accept ascii strings
    name: "StringLit"
    parse: (s) -> JSON.parse("{ \"s\": #{s} }").s
    type: PRIMITIVE_TYPES.STRING

@CharLit = class CharLit extends Literal
    name: "CharLit"
    parse: (s) ->
        s = s[1...-1]
        if s is "\\'"
            s = "'"
        else if s is "\""
            s = "\\\""
        JSON.parse("{ \"s\": \"#{s}\" }").s.charCodeAt(0)
    type: PRIMITIVE_TYPES.CHAR

@BoolLit = class BoolLit extends Literal
    name: "BoolLit"
    parse: (s) -> s is "true"
    type: PRIMITIVE_TYPES.BOOL

@NullPtr = class NullPtr extends Literal
    name: "NullPtr"
    parse: -> 0
    type: PRIMITIVE_TYPES.NULLPTR
