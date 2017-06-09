{ parser } = require './grammar'
astModule = require '../../ast'
{ compilationError } = require '../../messages'

module.exports = @

parser.yy = astModule

@parse = (code) ->
    try
        ast = parser.parse code
    catch error
        compilationError('PARSING_ERROR', null, 'error', error.message)

    ast