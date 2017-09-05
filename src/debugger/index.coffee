assert = require 'assert'

{ run } = require '../runtime'

module.exports = @

findLineInstruction = (program, line) ->
    for funcId, func of program.functions
        for instruction in func.instructions
            if instruction.locations?.lines.first <= line <= instruction.locations?.lines.last
                return instruction

    return null


differLine = (line, other) -> line? and other? and line isnt other

@Debugger = class Debugger
    constructor: ->
        @breakpointsToAdd = {}

    debug: (@program) ->
        assert @program, "Trying to debug with no program attached"

        @started = yes

        @addBreakpoints(Object.keys(@breakpointsToAdd)...)

        @iterator = run @program

        @continue(null, yes)

    continue: (condition = (-> no), initial = false) ->
        assert @started

        { value: @vm } = @iterator.next()

        if initial
            yield @vm

        until @vm.finished or @vm.instruction.breakpoint or condition(@vm)
            if @vm.isWaitingForInput()
                yield @vm

            { value: @vm } = @iterator.next()

        yield @vm

    stepOver: ->
        assert @started

        currentLine = @vm.instruction.locations?.lines.first
        currentStackLevel = @vm.controlStack.length

        yield from @continue((vm) -> differLine(currentLine, vm.instruction.locations?.lines.first) and vm.controlStack.length <= currentStackLevel)

    stepInto: ->
        assert @started

        currentLine = @vm.instruction.locations?.lines.first

        # If the current line changes it could be because of two reasons
        # A: There was no function call in the current line, just jump to the next line
        # B: There was a function call in the current line. Every function is assumed to start at a different
        #    line, so just jumps inside the called function
        yield from @continue((vm) ->
            differLine(vm.instruction.locations?.lines.first, currentLine)
        )

    stepOut: ->
        assert @started

        currentStackLevel = @vm.controlStack.length

        # > 0 so that the entry function cannot be debugged
        yield from @continue((vm) -> 0 < vm.controlStack.length < currentStackLevel and vm.instruction.locations?)

    stepInstruction: ->
        assert @started

        yield from @continue(-> yes)

    addBreakpoints: (lines...) ->
        if @program
            for line in lines
                instruction = findLineInstruction(@program, line)
                instruction?.breakpoint = yes

        for line in lines
            @breakpointsToAdd[line] = yes

    removeBreakpoints: (lines...) ->
        if @program
            for line in lines
                instruction = findLineInstruction(@program, line)
                delete instruction?.breakpoint

        for line in lines
            delete @breakpointsToAdd[line]
