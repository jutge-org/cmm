assert = require 'assert'
Error = require '../error'

module.exports = class Stack
    constructor: ->
        @stack = []
        @currentAR = null

    pushActivationRecord: ->
        @currentAR = {}
        @stack.push @currentAR

    popActivationRecord: ->
        assert @stack.length > 0

        @stack.pop()
        @currentAR =
            if @stack.length > 0 then @stack[@stack.length - 1] else null # If the else branch is executed it means the program has finished its execution

    # Parameter value is optional, if ommited means variable has been declared but not yet assigned
    defineVariable: (name, value = null) ->
        assert @currentAR?
        assert (typeof name is "string")

        @currentAR[name] = value

    getVariable: (name) ->
        assert @currentAR?
        assert (typeof name is "string")
        assert typeof @currentAR[name] isnt "undefined"

        if @currentAR[name] is null
            throw Error.GET_VARIABLE_NOT_ASSIGNED.complete('name', name)
        else
            @currentAR[name]

    setVariable: (name, value) ->
        assert @currentAR?
        assert (typeof name is "string")
        assert @currentAR[name]?

        @currentAR[name] = value
