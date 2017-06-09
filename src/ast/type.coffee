assert = require 'assert'

{ Ast } = require './ast'
utils = require '../utils'
{ compilationError } = require '../messages'

ASCII_MAP = (String.fromCharCode(char) for char in [0...128]).join("") + # ASCII
            "ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñóòôöõúùûü†°¢£§•¶ß®©™´¨≠ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄€‹›ﬁﬂ‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˜¯˘˙˚¸˝˛ˇ" # Extended ASCII

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

class Type extends Ast
    constructor: (@id, {
                    @castings = {}
                    @bytes
                    @stdTypeName
                    @isIntegral = no
                    @isNumeric  = no
                    @isAssignable = yes
                    @isReferenceable = @isAssignable
                 } = {}) ->
        super()

        if @stdTypeName?
            typedArray = new global[@stdTypeName + 'Array'](1)
            @tipify = (x) -> typedArray[0] = x; typedArray[0]
        else
            @tipify = (x) -> x

    getSymbol: -> @id.toLowerCase()

    canCastTo: (otherType, { strict = no } = {}) ->
        (strict and otherType.id is @id) or (not strict and @castings[otherType.id]?)

    instructionsForCast: (otherType, result, memoryReference) -> [ @castingGenerator[otherType.id](result, memoryReference) ]

    requiredAlignment: -> if @bytes is 0 then 1 else @bytes

    equalsNoConst: (other) -> @id is other.id

isVoidPointer = (type) -> type.isPointer and type.getElementType() is PRIMITIVE_TYPES.VOID
isConstConversionValid = (origin, other) -> not origin.isValueConst or other.isValueConst

@Pointer = class Pointer extends Type
    @bytes: 4

    constructor: (@elementType, { @isValueConst = no, @isIncomplete = no } = {}) ->
        super 'POINTER', {
            stdTypeName: 'Uint32',
            castings:
                COUT: (x) -> "0x" + utils.pad(x.toString(16), '0', 8)
        }

        @bytes = Pointer.bytes

    isPointer: yes

    getSymbol: ->
        if @isValueConst
            if @elementType.isPointer
                "#{@elementType.getSymbol()} const*"
            else
                "const #{@elementType.getSymbol()}*"
        else if @elementType.isArray
            "(*)(#{@elementType.getSymbol()})"
        else
            "#{@elementType.getSymbol()}*"

    getElementType: -> @elementType

    canCastTo: (otherType, { strict = no, allConst = yes } = {}) ->
        #console.log "#{@getSymbol()} -> #{otherType.getSymbol()}"
        if not strict and (otherType in [ PRIMITIVE_TYPES.BOOL, PRIMITIVE_TYPES.COUT ] or (isVoidPointer(otherType) and isConstConversionValid(this, otherType)))
            return yes
        else if otherType.isPointer
            if @isValueConst and not otherType.isValueConst
                return false
            else if otherType.isValueConst isnt @isValueConst
                return allConst and @getElementType().canCastTo(otherType.getElementType(), { strict: yes, allConst: (allConst and otherType.isValueConst) })
            else
                return @getElementType().canCastTo(otherType.getElementType(), { strict: yes, allConst: (allConst and otherType.isValueConst) })
        else
            return false

    instructionsForCast: (otherType, result, memoryReference) ->
        if result isnt memoryReference
            [ new Casting identity, result, memoryReference ]
        else
            []

    equalsNoConst: (other) -> other.isPointer and @getElementType().equalsNoConst(other.getElementType())

class NullPtr extends Type
    constructor: ->
        super 'NULLPTR', { isAssignable: no }

    getSymbol: -> "std::nullptr_t"

    canCastTo: (otherType) -> otherType.isPointer

    instructionsForCast: (otherType, result, memoryReference) ->
        if result isnt memoryReference
            [ new Casting identity, result, memoryReference ]
        else
            []

@Array = class Array extends Type
    constructor: (@size, @elementType, { @isValueConst = no } = {}) ->
        super 'ARRAY', {
            isAssignable: no, isReferenceable: yes
            castings:
                COUT: (x) -> "0x" + utils.pad(x.toString(16), '0', 8)
        }

        if not @size?
            @isIncomplete = yes
        else
            @bytes = @elementType.bytes*@size;


    getSymbol: (sizesCarry = []) ->
        main =
            if @elementType.isArray
                @elementType.getSymbol(sizesCarry.concat([@size]))
            else
                "#{@elementType.getSymbol()} #{(('[' + (size ? '') + ']') for size in sizesCarry.concat(@size)).join("")}"

        (if @isValueConst then "const " else "") + main

    canCastTo: (otherType, { strict = no } = {}) ->
        #console.log "#{@getSymbol()} -> #{otherType.getSymbol()}"
        if not strict and (otherType in [ PRIMITIVE_TYPES.BOOL, PRIMITIVE_TYPES.COUT ] or (isVoidPointer(otherType) and isConstConversionValid(this, otherType)))
            return yes
        else if otherType.isArray
            return (not strict or @size is otherType.size) and @getElementType().canCastTo(otherType.getElementType(), { strict: yes })
        else if otherType.isPointer
            if @isValueConst and not otherType.isValueConst
                return false
            else
                return not strict and @getElementType().canCastTo(otherType.getElementType(), { strict: yes })
        else
            return false


    instructionsForCast: (otherType, result, memoryReference) -> []

    getElementType: -> @elementType

    getBaseElementType: ->
        elementType = @getElementType()
        while elementType.isArray
            elementType = elementType.getElementType()
        elementType

    requiredAlignment: -> @getBaseElementType().requiredAlignment()

    getPointerType: -> new Pointer(@getElementType(), { @isValueConst })

    equalsNoConst: (other) -> other.isArray and other.size is @size and @getElementType().equalsNoConst(other.getElementType())

    isArray: yes



@FunctionType = class FunctionType extends Type
    constructor: (@returnType, @argTypes = []) ->

    canCastTo: -> no

    getSymbol: -> "#{@returnType}(#{(argType for argType in @argTypes).join(', ') })"

    equalsNoConst: (other) -> no

    isFunction: yes


@EXPR_TYPES = {
    RVALUE: 'RVALUE'
    LVALUE: 'LVALUE'
}

@PRIMITIVE_TYPES = PRIMITIVE_TYPES =
    VOID: new Type 'VOID', {
        isAssignable: no
        bytes: 1
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

    NULLPTR: new NullPtr

@PRIMITIVE_TYPES.LARGEST_ASSIGNABLE = utils.max((type for k, type of @PRIMITIVE_TYPES when type.isAssignable), 'bytes').arg

Object.freeze @PRIMITIVE_TYPES

class Casting extends Ast
    constructor: (@cast, children...) ->
        super children...

    execute: ({ memory }) ->
        [ dest, src ] = @children

        dest.write(memory, @cast(src.read(memory)))


for typeId, type of PRIMITIVE_TYPES
    type.castingGenerator = {}
    for castingId, fn of type.castings
        do (fn) ->
            type.castingGenerator[castingId] = (r, x) -> new Casting fn, r, x

# Returns a list of instructions necessary to cast memoryReference from
# actualType to expectedType. Could be empty
# The result is written in the same memory location as the input memoryReference
@ensureType = (memoryReference, actualType, expectedType, state, { releaseReference = yes, onReference } = {}) ->
    assert actualType instanceof Type
    assert expectedType instanceof Type

    if actualType isnt expectedType
        if actualType.canCastTo(expectedType)
            state.releaseTemporaries memoryReference if releaseReference
            result = onReference ? state.getTemporary expectedType
            instructions = actualType.instructionsForCast(expectedType, result, memoryReference)

            { instructions, result }
        else
            compilationError 'INVALID_CAST', 'origin', actualType.getSymbol(), 'dest', expectedType.getSymbol()
    else
        { instructions: [], result: memoryReference }