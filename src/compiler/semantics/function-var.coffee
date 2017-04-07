{ Variable } = require './variable'
{ TYPES } = require '../../ast/type'

module.exports = @

@FunctionVar = class extends Variable
    constructor: (id, @returnType, { @argTypes = [], specifiers } = {}) ->
        super id, TYPES.FUNCTION, { specifiers }

        @localsSize = 0
