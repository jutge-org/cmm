{ IO } = require '../runtime/io'

module.exports = @

@Program = class Program
    @ENTRY_FUNCTION: ".text"
    @MAIN_FUNCTION: "main"

    constructor: (@variables, @functions, @globalsSize) ->
        @outputListeners = []


        for funcId, func of @functions
            func.instructions = (instruction for instruction in func.instructions when not instruction.isDebugInfo)



    instructionsToString: ->
        s = ""
        for funcId, func of @functions
            s += funcId + ":" + "\n"
            for instruction in func.instructions
                s += instruction.toString().split("\n").map((x) -> "    " + x).join("\n") + "\n"

        s

    writeInstructions: ->
        for funcId, func of @functions
            console.log funcId + ":"
            for instruction in func.instructions
                console.log instruction.toString().split("\n").map((x) -> "    " + x).join("\n")

    attachMemory: (@memory) ->
    attachOutputListener: (fn, stream = IO.INTERLEAVED) -> @outputListeners.push({ fn, stream })
