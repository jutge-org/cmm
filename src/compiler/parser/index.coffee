{ parser } = require './grammar'
{ Ast } = require '../ast'
Error = require '../../error'

module.exports = @

parser.yy = { Ast }

@parse = (code) ->
    try
        ast = parser.parse code
    catch error
        throw Error.PARSE_ERROR.complete('error', error.message)

    ast