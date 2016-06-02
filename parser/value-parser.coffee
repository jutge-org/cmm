Ast = require './ast'

{ TYPES, LITERALS } = Ast

module.exports = @

@parseLiteral = (T) ->
    switch T.getType()
        when LITERALS.DOUBLE
            T.setChild(0, parseFloat(T.getChild(0)))
            return TYPES.DOUBLE
        when LITERALS.INT
            T.setChild(0, parseInt(T.getChild(0)))
            return TYPES.INT
        when LITERALS.STRING
            T.setChild(0, JSON.parse("{ \"s\": #{T.getChild(0)} }").s) # HACK: SUCH HACKS, eval(T.getChild(0)) also works, but we're not sure its 100% secure
            return TYPES.STRING
        when LITERALS.CHAR
            T.setChild(0, JSON.parse("{ \"s\": \"#{T.getChild(0)[1...-1]}\" }").s.charCodeAt(0)) # HACK: SUCH HACKS^2
            return TYPES.CHAR
        when LITERALS.BOOL
            T.setChild(0, T.getChild(0) is "true")
            return TYPES.BOOL
        else
            assert false

@parseInputWord = (word, type) ->
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
