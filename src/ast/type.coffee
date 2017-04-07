assert = require 'assert'

{ Ast } = require './ast'
utils = require '../utils'
Error = require '../error'

class Type extends Ast
    constructor: (@id, {
                    @castings = {}
                    @size
                    @bytes
                    @stdTypeName
                    @isIntegral = no
                    @isNumeric  = no
                    @isAssignable = yes
                 } = {}) ->
        super()

        if @stdTypeName?
            typedArray = new global[@stdTypeName + 'Array'](1)
            @tipify = (x) -> typedArray[0] = x; typedArray[0]
        else
            @tipify = (x) -> x

    getSymbol: -> @id


@TYPES = TYPES =
    VOID: new Type 'VOID', {
        isAssignable: no
    }

    INT: new Type 'INT', {
        size: 32
        bytes: 4
        isIntegral: yes
        isNumeric: yes
        castings:
            DOUBLE: (x) ->
            CHAR: (x) ->
            BOOL: (x) ->
            COUT: (x) ->

        stdTypeName: 'Int32'

    }

    DOUBLE: new Type 'DOUBLE', {
        size: 64
        bytes: 8
        isNumeric: yes
        castings:
            INT: (x) ->
            CHAR: (x) ->
            BOOL: (x) ->
            COUT: (x) ->
        stdTypeName: 'Float64'
    }

    STRING: new Type 'STRING', {
        bytes: 0
    }

    CHAR: new Type 'CHAR', {
        size: 8
        bytes: 1
        isIntegral: yes
        castings:
            INT: (x) ->
            DOUBLE: (x) ->
            BOOL: (x) ->
            COUT: (x) ->

        stdTypeName: 'Int8'
    }

    BOOL: new Type 'BOOL', {
        size: 1
        bytes: 1
        isIntegral: yes
        castings:
            INT: (x) ->
            DOUBLE: (x) ->
            CHAR: (x) ->
            COUT: (x) ->

        stdTypeName: 'Uint8'
    }

    FUNCTION: new Type 'FUNCTION', {
        isAssignable: no
    }

    CIN: new Type 'CIN', {
        isAssignable: no
        castings:
            BOOL: (x) ->
    }

    COUT: new Type 'COUT', {
        isAssignable: no
    }

@TYPES.LARGEST_ASSIGNABLE = utils.max((type for k, type of @TYPES when type.isAssignable), 'bytes')

Object.freeze @TYPES

class Casting extends Ast
    constructor: (@interpret, children...) ->
        super children...

for typeId, type of TYPES
    for castingId, fn of type.castings
        type.castings[castingId] = (r, x) -> new Casting fn, r, x

# Returns a list of instructions necessary to cast memoryReference from
# actualType to expectedType. Could be empty
# The result is written in the same memory location as the input memoryReference
@ensureType = (memoryReference, actualType, expectedType, state, { releaseReference = yes } = {}) ->
    assert actualType instanceof Type
    assert expectedType instanceof Type

    if actualType isnt expectedType
        if actualType.castings[expectedType.id]?
            state.releaseTemporaries memoryReference if releaseReference
            result = state.getTemporary expectedType
            { instructions: [ actualType.castings[expectedType.id](result, memoryReference) ], result }
        else
            throw Error.INVALID_CAST.complete('origin', actualType.id, 'dest', expectedType.id)
    else
        { instructions: [], result: memoryReference }