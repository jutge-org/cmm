{ compile } = require './compiler'
interpreter = require './runtime'

module.exports = @

@compile = compile

@execute = (ast, input) ->
    interpreter.load ast
    interpreter.run input