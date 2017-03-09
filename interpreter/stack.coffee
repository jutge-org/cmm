assert = require 'assert'
Error = require '../error'

module.exports = class Stack
    @stack: []
    @currentAR: null

    @pushActivationRecord: (funcName, args) ->
        @currentAR = { scopesStack: [], variables: {}, funcName: funcName, args: args }
        @stack.push @currentAR

    @popActivationRecord: ->
        assert @stack.length > 0

        @stack.pop()
        @currentAR =
            if @stack.length > 0 then @stack[@stack.length - 1] else null

    # Parameter value is optional, if ommited means variable has been declared but not yet assigned
    @defineVariable: (name, type, value = null) ->
        assert @currentAR?
        assert (typeof name is "string")

        @currentAR.variables[name] = { type: type, value: value }

    @getVariable: (name) ->
        assert @currentAR?
        assert (typeof name is "string")
        assert typeof @currentAR.variables[name].value isnt "undefined"

        if @currentAR.variables[name] is null
            throw Error.GET_VARIABLE_NOT_ASSIGNED.complete('name', name)
        else
            @currentAR.variables[name].value

    @getVariableType: (name) ->
        assert @currentAR?
        assert (typeof name is "string")
        assert typeof @currentAR.variables[name].value isnt "undefined"

        @currentAR.variables[name].type

    @setVariable: (name, value) ->
        assert @currentAR?
        assert (typeof name is "string")
        assert typeof @currentAR.variables[name].value isnt "undefined"

        @currentAR.variables[name].value = value

    @openNewScope: ->
        assert @currentAR?
        variablesSet = {}
        variablesSet[varId] = yes for varId of @currentAR.variables
        @currentAR.scopesStack.push variablesSet

    @closeScope: ->
        assert @currentAR?.scopesStack.length > 0

        variablesSet = @currentAR.scopesStack.pop()
        for variable of @currentAR.variables when variable not of variablesSet
            delete @currentAR.variables[variable]
