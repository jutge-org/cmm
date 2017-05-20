assert = require 'assert'

utils = require '../../utils'
Error = require '../../error'
{ MemoryReference } = require '../../ast/memory-reference'

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

        @defineVariable func, Error.FUNCTION_REDEFINITION.complete('name', func.id)
        @addressOffsetCopy = @addressOffset
        @addressOffset = 0
        @functionId = func.id # Necessary for a return statement or funcarg to know its function id
        @functions[@functionId] = func

        @openScope()

    endFunction: ->
        assert @functionId?

        @variables[@functionId][0].stackSize = @addressOffset
        @addressOffset = @addressOffsetCopy
        delete @functionId

        @closeScope()

    defineVariable: (variable, onError) ->
        { id } = variable

        variable.isFunctionArgument = @insideFunctionArgumentDefinitions

        if variable.isFunctionArgument
            func = @getFunction()
            assert func?
            func.argTypes.push variable.type

        if @variables[id]?
            if @variables[id][@scopeLevel]?
                throw (onError ? Error.VARIABLE_REDEFINITION.complete("name", id))
        else
            @variables[id] = {}

        if variable.type.isReferenceable
            variable.memoryReference = MemoryReference.from(variable.type, @addressOffset, if @scopeLevel > 0 then 1 else 0)
            @addressOffset += variable.type.bytes

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
        ret = MemoryReference.from(type, @temporaryAddressOffset, MemoryReference.TMP)
        @temporaryAddressOffset += type.bytes # TODO: Check that it doesn't go over 4096
        ret

    # HACK: This assumes that the released temporary is the one that was last requested
    releaseTemporaries: (references...) ->

        for reference in references
            if reference.isTemporary
                #console.log "Release #{reference.getType().bytes}, on #{reference.getAddress()}"
                @temporaryAddressOffset -= reference.getType().bytes
                assert @temporaryAddressOffset >= 0

    iAmInsideFunctionArgumentDefinitions: -> @insideFunctionArgumentDefinitions

    beginFunctionArgumentDefinitions: -> @insideFunctionArgumentDefinitions = yes

    endFunctionArgumentDefinitions: -> @insideFunctionArgumentDefinitions = no
