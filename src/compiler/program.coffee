module.exports = @

@Program = class Program
    @ENTRY_FUNCTION: ".text"

    constructor: (@variables, @functions, @globalsSize) ->

    writeInstructions: ->
        for funcId, func of @functions
            console.log funcId + ":"
            for instruction in func.instructions
                console.log instruction.toString().split("\n").map((x) -> "    " + x).join("\n")