module.exports = @

@Variable = class Variable
    constructor: (@name, @type, { @specifiers = {}, @isTmp = no, @isFunctionArgument = no } = {}) ->
        @specifiers.const ?= no