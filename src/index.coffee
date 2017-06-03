{ compile } = require './compiler'
{ run, runSync } = require './runtime'
{ Memory } = require './runtime/memory'

module.exports = @

@compile = compile
@run = run
@runSync = runSync
@Memory = Memory