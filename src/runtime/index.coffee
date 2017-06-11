assert = require 'assert'
Allocator = require 'malloc'

{ IO } = require './io'
{ Program: { ENTRY_FUNCTION } } = require '../compiler/program'
{ Memory } = require './memory'
{ MemoryReference } = require '../ast/memory-reference'
{ PRIMITIVE_TYPES, Pointer } = require '../ast/type'
utils = require '../utils'

{ executionError } = require '../messages'

module.exports = @

class VM
    constructor: (program, input) ->
        @func = program.functions[ENTRY_FUNCTION]

        @instructions = @func.instructions

        @pointers = { instruction: 0, stack: 0, temporaries: 0 }

        @io = new IO
        @io.setInput IO.STDIN, input if input?
        @io.setOutputListeners program.outputListeners

        @memory = program.memory ? new Memory
        @memory.setPointers @pointers

        @allocator = new Allocator @memory.heapBuffer

        @allocatedPointers = {} # Turns out the malloc library doesn't always check on whether the pointer being
                                # free'd was previously allocated, and could lead to a hang on posterior allocations,
                                # so we need to keep track of it

        if program.globalsSize > 0
            @staticHeapAddress = @allocator.calloc(program.globalsSize)

        @controlStack = []

        { @variables, @functions } = program

        @finished = no

        @instruction = @instructions[@pointers.instruction]

        @hasEndedInput = no

    isWaitingForInput: -> not @hasEndedInput and @instruction.isRead and @io.getStream(IO.STDIN).length is 0
    endOfInput: -> @hasEndedInput = yes

    computeResults: ->
        assert @finished, "Try to get results from VM which has not finished execution"

        @status ?= MemoryReference.from(PRIMITIVE_TYPES.INT, null, MemoryReference.RETURN).read(@memory)
        @stdout = @io.getStream IO.STDOUT
        @stderr = @io.getStream IO.STDERR
        @output = @io.getStream IO.INTERLEAVED

        @allocator.free(@staticHeapAddress) if @staticHeapAddress?

        for address of @allocatedPointers
            @allocator.free address&0x7FFFFFF # TODO: Should warn user of memory leakage

    executionError: (error) ->
        @finished = yes
        @io.output(IO.STDERR, error.message)
        @status = error.code

    input: (string) -> @io.setInput(IO.STDIN, string)

    alloc: (size) ->
        try
            initialPointer = @allocator.calloc(size)

            throw new Error() if initialPointer is 0
            pointer = new Pointer(PRIMITIVE_TYPES.VOID).tipify(initialPointer | 0x80000000) # Add heap mark
            @allocatedPointers[pointer] = yes
        catch error
            executionError(this, 'CANNOT_ALLOCATE', "size", size)

        pointer


    free: (offset) ->
        error = not @allocatedPointers[offset]?

        offsetMalloc = offset&0x7FFFFFFF # Remove heap mark

        unless error
            try
                result = @allocator.free(offsetMalloc)
            catch err
                error = yes

        if error
            executionError(this, 'INVALID_FREE_POINTER', 'pointer', "0x" + utils.pad(offset.toString(16), '0', 8))

        delete @allocatedPointers[offset]

        result

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
