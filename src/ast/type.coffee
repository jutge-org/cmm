assert = require 'assert'

{ Ast } = require './ast'
utils = require '../utils'
Error = require '../error'

ASCII_MAP = (String.fromCharCode(char) for char in [0...128]).join("") + # ASCII
            "ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñóòôöõúùûü†°¢£§•¶ß®©™´¨≠ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄€‹›ﬁﬂ‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˜¯˘˙˚¸˝˛ˇ" # Extended ASCII

class Type extends Ast
    constructor: (@id, {
                    @castings = {}
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

    canCastTo: (otherType) -> @castings[otherType.id]?

    instructionsForCast: (otherType, result, memoryReference) -> [ @castingGenerator[otherType.id](result, memoryReference) ]



@Array = class Array extends Type
    constructor: (@sizes, @type) ->
        super 'ARRAY', {}

        @bytes =
            if @sizes[0] isnt null
                prod = @type.bytes
                prod *= size for size in sizes
                prod
            else
                4 # TODO: Should be BASIC_TYPES.POINTER.SIZE

    getSymbol: -> "Array<#{type.getSymbol()}>#{("[#{size}]" for size in @sizes).join("")}"

    equals: (other) ->
        if @type isnt other.type or @sizes.length isnt other.sizes.length
            no
        else
            for size, i in @sizes
                if size isnt other.sizes[i]
                    return no
            yes

    canCastTo: (otherType) ->
        no
        # TODO: Implement

    instructionsForCast: (otherType, result, memoryReference) ->
        # TODO: Implement

digits = (x) ->
    x = Math.floor x
    c = 0
    while x > 0
        ++c
        x //= 10
    c

roundCout = (x) ->
    d = digits(x)
    decimalPlacesRounder = 10**(6 - d)
    x = Math.round(x*decimalPlacesRounder)/decimalPlacesRounder

identity = (x) -> x


@EXPR_TYPES = {
    RVALUE: 'RVALUE'
    LVALUE: 'LVALUE'
}

@BASIC_TYPES = BASIC_TYPES =
    VOID: new Type 'VOID', {
        isAssignable: no
    }

    INT: new Type 'INT', {
        bytes: 4
        isIntegral: yes
        isNumeric: yes
        castings:
            DOUBLE: identity
            CHAR: identity
            BOOL: (x) -> x isnt 0
            COUT: (x) -> x.toString()

        stdTypeName: 'Int32'
    }

    DOUBLE: new Type 'DOUBLE', {
        bytes: 8
        isNumeric: yes
        castings:
            INT: identity
            CHAR: identity
            BOOL: (x) -> x isnt 0
            COUT: (x) ->
                if isNaN x
                    "-nan"
                else if x is Number.POSITIVE_INFINITY
                    "inf"
                else if x is Number.NEGATIVE_INFINITY
                    "-inf"
                else
                    abs = Math.abs(x)
                    if abs >= 1000000 or (abs <= 0.000001 and abs isnt 0)
                        [ d, o ] = x.toExponential().split('e')
                        x = roundCout(d) + 'e' + o
                    else
                        x = roundCout(x)
                    x.toString()

        stdTypeName: 'Float64'
    }

    STRING: new Type 'STRING', {
        bytes: 0
        castings:
            COUT: identity
    }

    CHAR: new Type 'CHAR', {
        bytes: 1
        isIntegral: yes
        isNumeric: yes
        castings:
            INT: identity
            DOUBLE: identity
            BOOL: (x) -> x isnt 0
            COUT: (x) -> ASCII_MAP[x&0x000000FF]

        stdTypeName: 'Int8'
    }

    BOOL: new Type 'BOOL', {
        bytes: 1
        isIntegral: yes
        castings:
            INT: identity
            DOUBLE: identity
            CHAR: identity
            COUT: (x) -> if x then "1" else "0"

        stdTypeName: 'Uint8'
    }

    FUNCTION: new Type 'FUNCTION', {
        isAssignable: no
    }

    CIN: new Type 'CIN', {
        isAssignable: no
        castings:
            BOOL: (x) -> x
    }

    COUT: new Type 'COUT', {
        isAssignable: no
    }

@BASIC_TYPES.LARGEST_ASSIGNABLE = utils.max((type for k, type of @BASIC_TYPES when type.isAssignable), 'bytes').arg

Object.freeze @BASIC_TYPES

class Casting extends Ast
    constructor: (@cast, children...) ->
        super children...

    execute: ({ memory }) ->
        [ dest, src ] = @children

        dest.write(memory, @cast(src.read(memory)))

        yes

for typeId, type of BASIC_TYPES
    type.castingGenerator = {}
    for castingId, fn of type.castings
        do (fn) ->
            type.castingGenerator[castingId] = (r, x) -> new Casting fn, r, x

# Returns a list of instructions necessary to cast memoryReference from
# actualType to expectedType. Could be empty
# The result is written in the same memory location as the input memoryReference
@ensureType = (memoryReference, actualType, expectedType, state, { releaseReference = yes } = {}) ->
    assert actualType instanceof Type
    assert expectedType instanceof Type

    if actualType isnt expectedType
        if actualType.canCastTo(expectedType)
            state.releaseTemporaries memoryReference if releaseReference
            result = state.getTemporary expectedType
            { instructions: actualType.instructionsForCast(expectedType, result, memoryReference), result }
        else
            throw Error.INVALID_CAST.complete('origin', actualType.id, 'dest', expectedType.id)
    else
        { instructions: [], result: memoryReference }