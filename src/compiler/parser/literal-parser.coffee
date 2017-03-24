{ Ast: { LITERALS, TYPES } } = require '../ast'

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