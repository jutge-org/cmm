assert = require 'assert'

{ IO } = require './io'

{ Program: { ENTRY_FUNCTION } } = require '../compiler/program'
{ Memory } = require './memory'

module.exports = @

@run = (program, input) ->
    func = program.functions[ENTRY_FUNCTION]
    instructions = func.instructions
    pointers = { instruction: 0, stack: 0, temporaries: 0 }
    io = new IO
    io.setInput IO.STDIN, input

    memory = new Memory pointers

    state = { memory, instructions, pointers, variables: program.variables, functions: program.functions, controlStack: [], function: func, io }

    state.finished = false
    until state.finished
        state.instructions[state.pointers.instruction].execute state
        ++state.pointers.instruction

    { stdout: io.getStream(IO.STDOUT), stderr: io.getStream(IO.STDERR), output: io.getStream(IO.INTERLEAVED)}