
{ Ast } = require './ast'

module.exports = @

@AddressOf = class AddressOf extends Ast
    compile: (state) ->