{ Ast } = require './ast'
{ IO } = require '../runtime/io'
{ parseInput } = require '../runtime/input-parser'

module.exports = @

@Read = class Read extends Ast
    execute: ({ memory, io }) ->
        [ booleanReference, idReference ] = @children

        word = io.getWord IO.STDIN
        read = no

        if word?
            { leftover, value } = parseInput word, idReference.getType()

            if value?
                if leftover.length > 0
                    io.unshiftWord(IO.STDIN, leftover)

                idReference.write(memory, value)

                read = yes

        booleanReference.write memory, if read then 1 else 0

        yes
