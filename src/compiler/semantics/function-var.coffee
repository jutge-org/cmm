{ Variable } = require './variable'
{ BASIC_TYPES } = require '../../ast/type'

module.exports = @

@FunctionVar = class extends Variable
    constructor: (id, @returnType, { @argTypes = [], specifiers } = {}) ->
        super id, BASIC_TYPES.FUNCTION, { specifiers }

        @localsSize = 0
