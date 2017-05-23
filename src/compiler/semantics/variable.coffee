module.exports = @

@Variable = class Variable
    constructor: (@id, @type, { @specifiers = {}, @isTmp = no, @isFunctionArgument = no } = {}) ->
        @specifiers.CONST ?= no