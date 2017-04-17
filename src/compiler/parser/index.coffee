{ parser } = require './grammar'
astModule = require '../../ast'
Error = require '../../error'

module.exports = @

parser.yy = astModule

@parse = (code) ->
    try
        ast = parser.parse code
    catch error
        console.log error
        throw Error.PARSE_ERROR.complete('error', error.message)

    ast