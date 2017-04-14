{ compile } = require './compiler'
{ run } = require './runtime'

module.exports = @

@compile = compile
@run = run