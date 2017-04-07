{ Ast: { TYPES } } = require '../ast/ast'

module.exports = @

@parseInput = (word, type) ->
# FIXME: This should be rewritten, it's totally broken
    switch type
        when TYPES.INT
            unless /[0-9\-]/.test(word[0])
                index = 0
            else
                index = word[1..].search(/[^0-9]/)
                if index >= 0
                    ++index

            if index > 0
                value: parseInt word[0...index]
                leftover: word[index..]
            else if index is 0
                value: null
                leftover: word
            else
                value: parseInt word
                leftover: ""
        when TYPES.DOUBLE
            index = 0
            end = no
            foundDot = no

            if /[0-9\-\.]/.test(word[0])
                if word[0] is '.'
                    foundDot = true
                index = 1
                while index < word.length and not end
                    if word[index] is '.'
                        if foundDot
                            end = true
                        else
                            foundDot = yes
                            ++index
                    else if /[0-9]/.test(word[index])
                        ++index
                    else
                        end = true

            if index > 0
                value: parseFloat word[0...index]
                leftover: word[index..]
            else if index is 0
                value: null
                leftover: word
            else
                value: parseFloat word
                leftover: ""

        when TYPES.BOOL
            value = parseInt word
            if value not in [0,1]
                leftover: word
                value: null
            else
                value: value is 1
                leftover: word[1..]
        when TYPES.STRING
            value: word
            leftover: ""
        when TYPES.CHAR
            value: word.charCodeAt 0
            leftover: word[1..]
        else
            assert false
