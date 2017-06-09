assert = require 'assert'

utils = require '../../utils'
{ compilationError } = require '../../messages'
{ MemoryReference } = require '../../ast/memory-reference'
{ alignTo } = require '../../utils'
{ Memory } = require '../../runtime/memory'

module.exports = @

@CompilationState = class CompilationState
    constructor: ->
        @variables = {}
        @functions = {}
        @scopeLevel = 0 # In order to be able to distinguish redefined and override variables
        @addressOffset = 0 # So as to define the offset of each local/global variable in the function stack/heap
        @temporaryAddressOffset = 0
        @variablesCopyStack = []
        @insideFunctionArgumentDefinitions = no
        @insideFunctionReturnDefinition = no
        @warnings = []

    openScope: ->
        variablesCopy = {}
        for variable, scopes of @variables
            variablesCopy[variable] = utils.clone scopes

        @variablesCopyStack.push variablesCopy

        ++@scopeLevel

    closeScope: ->
        @variables = @variablesCopyStack.pop()

        --@scopeLevel

    newFunction: (func) ->
        assert not @functionId?
        assert @scopeLevel is 0

        @maxTmpSize = 0
        @defineVariable func
        @addressOffsetCopy = @addressOffset
        @addressOffset = 0
        @functionId = func.id # Necessary for a return statement or funcarg to know its function id
        @functions[@functionId] = func

        @openScope()

    endFunction: ->
        assert @functionId?

        assert @temporaryAddressOffset is 0

        stackSize = alignTo(@addressOffset, 16)

        if stackSize > Memory.SIZES.stack
            compilationError('MAX_STACK_SIZE_EXCEEDED', 'id', @functionId, 'size', stackSize, 'limit', Memory.SIZES.stack)

        @functions[@functionId].stackSize = alignTo(@addressOffset, 16)
        @functions[@functionId].maxTmpSize = @maxTmpSize

        @addressOffset = @addressOffsetCopy
        delete @functionId

        @closeScope()

    defineVariable: (variable) ->
        { id } = variable

        variable.isFunctionArgument = @insideFunctionArgumentDefinitions

        if variable.isFunctionArgument
            func = @getFunction()
            assert func?
            func.type.argTypes.push variable.type

        if @variables[id]?
            if @variables[id][@scopeLevel]?
                compilationError('VARIABLE_REDEFINITION', "name", id)
        else
            @variables[id] = {}

        if variable.type.isReferenceable
            requiredAlignment = variable.type.requiredAlignment()

            desiredAddressOffset = alignTo(@addressOffset, requiredAlignment)

            variable.memoryReference = MemoryReference.from(variable.type, desiredAddressOffset, if @scopeLevel > 0 then 1 else 0)
            @addressOffset = desiredAddressOffset + variable.type.bytes

        @variables[id][@scopeLevel] = variable

    getVariable: (id) ->
        if @variables[id]?
            max = -1
            for level of @variables[id]
                if level is @scopeLevel
                    return @variables[id][level]
                else if level > max
                    max = level

            if max isnt -1
                return @variables[id][max]

        return null


    getFunction: (id = @functionId) -> @functions[id]

    getTemporary: (type) ->
        #console.log "Get #{type.bytes}"

        desiredAddressOffset = alignTo(@temporaryAddressOffset, type.requiredAlignment())
        previousOffset = @temporaryAddressOffset
        @temporaryAddressOffset = desiredAddressOffset + type.bytes
        @maxTmpSize = Math.max(@temporaryAddressOffset, @maxTmpSize)

        if @temporaryAddressOffset > Memory.SIZES.tmp
            compilationError 'TEMPORARY_ADDRESS_LIMIT'

        ret = MemoryReference.from(type, desiredAddressOffset, MemoryReference.TMP, @temporaryAddressOffset - previousOffset)
        ret

    # HACK: This assumes that the released temporary is the one that was last requested
    releaseTemporaries: (references...) ->
        #console.log arguments.callee.caller.toString()

        i = 0
        while i < references.length
            reference = references[i++]

            if reference.containsTemporaries?()
                references = references.concat(reference.getTemporaries())

            if reference.isTemporary and not reference.alreadyReleased
                reference.alreadyReleased = yes
                #console.log "Release #{reference.getType().bytes}, on #{reference.getAddress()}"
                @temporaryAddressOffset -= reference.getOccupation()
                assert @temporaryAddressOffset >= 0

    iAmInsideFunctionArgumentDefinitions: -> @insideFunctionArgumentDefinitions

    beginFunctionArgumentDefinitions: -> @insideFunctionArgumentDefinitions = yes

    endFunctionArgumentDefinitions: -> @insideFunctionArgumentDefinitions = no

    iAmInsideFunctionReturnDefinition: -> @insideFunctionReturnDefinition

    beginFunctionReturnDefinition: -> @insideFunctionReturnDefinition = yes

    endFunctionReturnDefinition: -> @insideFunctionReturnDefinition = no

    warn: (warning) -> warnings.push warning