assert = require 'assert'

{ IO } = require './io'

{ Program: { ENTRY_FUNCTION } } = require '../compiler/program'
{ Memory } = require './memory'
{ MemoryReference } = require '../ast/memory-reference'
{ PRIMITIVE_TYPES } = require '../ast/type'

module.exports = @

class VM
    constructor: (program, input) ->
        @func = program.functions[ENTRY_FUNCTION]

        @instructions = @func.instructions

        @pointers = { instruction: 0, stack: 0, temporaries: 0 }

        @io = new IO
        @io.setInput IO.STDIN, input if input?

        @memory = new Memory @pointers

        @controlStack = []

        { @variables, @functions } = program

        @finished = no

        @instruction = @instructions[@pointers.instruction]

    isWaitingForInput: -> @instruction.isRead and @io.getStream(IO.STDIN).length is 0

    computeResults: ->
        assert @finished, "Try to get results from VM which has not finished execution"

        @status ?= MemoryReference.from(PRIMITIVE_TYPES.INT, null, MemoryReference.RETURN).read(@memory)
        @stdout = @io.getStream IO.STDOUT
        @stderr = @io.getStream IO.STDERR
        @output = @io.getStream IO.INTERLEAVED

    executionError: (error) ->
        @finished = yes
        @io.output(IO.STDERR, error.message)
        @status = error.code

    input: (string) -> @io.setInput(IO.STDIN, string)

@run = (program, input) ->
    vm = new VM program, input

    until vm.finished
        vm.instruction = vm.instructions[vm.pointers.instruction]
        yield vm
        vm.instruction.execute vm
        ++vm.pointers.instruction

    vm.computeResults()

    yield vm


@runSync = (program, input) ->
    vm = new VM program, input

    until vm.finished
        vm.instructions[vm.pointers.instruction].execute vm
        ++vm.pointers.instruction

    vm.computeResults()

    vm