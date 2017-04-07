{ Ast } = require './ast'
{ TYPES } = require './type'

module.exports = @

@Read = class Read extends Ast
    # [ booleanReference, idReference ] = @children