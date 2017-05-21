{ Variable } = require './variable'
{ PRIMITIVE_TYPES } = require '../../ast/type'

module.exports = @

@FunctionVar = class extends Variable
    constructor: (id, type, { specifiers } = {}) ->
        super id, type, { specifiers }

        @stackSize = 0