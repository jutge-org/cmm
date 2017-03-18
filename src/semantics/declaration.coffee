# Note that this could be named 'variable' or 'function' among other possibilities
# Declaration though is the most general term


module.exports = class Declaration
    constructor: (@type, @specifiers = {}) ->
        { CONST = no } = @specifiers