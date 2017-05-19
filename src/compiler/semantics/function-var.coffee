{ Variable } = require './variable'
{ PRIMITIVE_TYPES } = require '../../ast/type'

module.exports = @

@FunctionVar = class extends Variable
    constructor: (id, @returnType, { @argTypes = [], specifiers } = {}) ->
        super id, PRIMITIVE_TYPES.FUNCTION, { specifiers }

        @localsSize = 0
