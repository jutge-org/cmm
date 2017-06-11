{ compile } = require './compiler'
{ run, runSync } = require './runtime'
{ Memory } = require './runtime/memory'
{ Debugger } = require './debugger'

module.exports = @

@compile = compile
@run = run
@runSync = runSync
@Memory = Memory
@Debugger = Debugger
