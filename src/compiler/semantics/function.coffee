{ Variable } = require './variable'
{ Ast: { TYPES } } = require '../ast'

module.exports = @

@Function = class Function extends Variable
    constructor: (@name, @returnType, { @argTypes = [], @specifiers } = {}) ->
        super @name, TYPES.FUNCTION, { @specifiers }
