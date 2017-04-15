{ compile } = require './compiler'
{ run, runSync } = require './runtime'

module.exports = @

@compile = compile
@run = run
@runSync = runSync