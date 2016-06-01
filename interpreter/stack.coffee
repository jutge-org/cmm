assert = require 'assert'
Error = require '../error'

module.exports = class Stack
    @stack: []
    @currentAR: null
    @scopesStack: []

    @pushActivationRecord: ->
        @currentAR = {}
        @stack.push @currentAR

    @popActivationRecord: ->
        assert @stack.length > 0

        @stack.pop()
        @currentAR =
            if @stack.length > 0 then @stack[@stack.length - 1] else null

    # Parameter value is optional, if ommited means variable has been declared but not yet assigned
    @defineVariable: (name, value = null) ->
        assert @currentAR?
        assert (typeof name is "string")

        @currentAR[name] = value

    @getVariable: (name) ->
        assert @currentAR?
        assert (typeof name is "string")
        assert typeof @currentAR[name] isnt "undefined"

        if @currentAR[name] is null
            throw Error.GET_VARIABLE_NOT_ASSIGNED.complete('name', name)
        else
            @currentAR[name]

    @setVariable: (name, value) ->
        assert @currentAR?
        assert (typeof name is "string")
        assert typeof @currentAR[name] isnt "undefined"

        @currentAR[name] = value

    @openNewScope: ->
        assert @currentAR?
        variablesSet = {}
        variablesSet[varId] = yes for varId of @currentAR
        @scopesStack.push variablesSet

    @closeScope: ->
        assert @scopesStack.length > 0

        variablesSet = @scopesStack.pop()
        for variable of @currentAR when variable not of variablesSet
            delete @currentAR[variable]
