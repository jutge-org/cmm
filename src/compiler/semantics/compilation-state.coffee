assert = require 'assert'

utils = require '../../utils'
Error = require '../../error'
{ HeapReference, StackReference, TmpReference } = require '../../ast/memory-reference'

module.exports = @

@CompilationState = class CompilationState
    constructor: ->
        @definedVariables = {}
        @functions = {}
        @scopeLevel = 0 # In order to be able to distinguish redefined and override variables
        @addressOffset = 0 # So as to define the offset of each local/global variable in the function stack/heap
        @temporaryAddressOffset = 0

    openScope: ->
        @definedVariablesCopy = {}
        for variable, scopes of @definedVariables
            @definedVariablesCopy[variable] = utils.clone scopes

        ++@scopeLevel

    closeScope: ->
        @definedVariables = @definedVariablesCopy
        --@scopeLevel

    newFunction: (func) ->
        assert not @functionId?
        assert @scopeLevel is 0

        @defineVariable func, Error.FUNCTION_REDEFINITION.complete('name', func.id)
        @addressOffsetCopy = @addressOffset
        @addressOffset = 0
        @functionId = func.id # Necessary for a return statement or funcarg to know its function id

        @openScope()

    endFunction: ->
        assert @functionId?

        @definedVariables[@functionId][0].stackSize = @addressOffset
        @addressOffset = @addressOffsetCopy
        @functions[@functionId] = @definedVariables[@functionId][0]
        delete @functionId

        @closeScope()

    defineVariable: (variable, onError) ->
        { id } = variable

        if @definedVariables[id]?
            if @definedVariables[id][@scopeLevel]?
                throw (onError ? Error.VARIABLE_REDEFINITION.complete("name", id))
        else
            @definedVariables[id] = {}

        if variable.type.isAssignable
            referenceConstructor = if @scopeLevel is 0 then HeapReference else StackReference
            variable.memoryReference = new referenceConstructor(variable.type, @addressOffset)
            @addressOffset += variable.type.bytes


        @definedVariables[id][@scopeLevel] = variable

    getVariable: (id) ->
        if @definedVariables[id]?
            max = -1
            for level of @definedVariables[id]
                if level is @scopeLevel
                    return @definedVariables[id][level]
                else if level > max
                    max = level

            if max isnt -1
                return @definedVariables[id][max]

        return null

    getTemporary: (type) ->
        ret = new TmpReference type, @temporaryAddressOffset
        @temporaryAddressOffset += type.bytes # TODO: Check that it doesn't go over 4096
        ret

    # HACK: This assumes that the released temporary is the one that was last requested
    releaseTemporaries: (references...) ->
        for reference in references
            if reference.isTemporary
                @temporaryAddressOffset -= reference.getType().bytes
                assert @temporaryAddressOffset >= 0
