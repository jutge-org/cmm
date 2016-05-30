assert = require 'assert'

Stack = require './stack'
Ast   = require '../parser/ast'

{ NODES, OPERATORS, LITERALS } = Ast

module.exports = @

@evaluateExpression = (T) ->
    assert T?
    switch T.getType()
        when LITERALS.BOOL
            T.getChild(0)
        when LITERALS.INT
            T.getChild(0)
        when LITERALS.STRING 
            T.getChild(0)
        when NODES.ID
            Stack.getVariable(T.getChild 0).getValue()
        else 
            console.log('Expression evaluation not implemented yet')
            null