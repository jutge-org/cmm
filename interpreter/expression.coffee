assert = require 'assert'

Stack = require './stack'
Ast   = require '../parser/ast'

{ NODES, OPERATORS, LITERALS } = Ast

module.exports = @

@evaluateExpression = (T) ->
    assert T?
    switch T.getType()
        when LITERALS.STRING 
            return T.getChild(0)
        when NODES.ID
            return Stack.getVariable(T.getChild 0).getValue()
        else 
            console.log('Expression evaluation not implemented yet')
            null