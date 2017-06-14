{ Ast } = require './ast'

module.exports = @

@DebugInfo = class DebugInfo extends Ast
    isDebugInfo: yes
    execute: ->

@OpenScope = class OpenScope extends DebugInfo
    name: "OpenScope"

    openScope: yes


@CloseScope = class CloseScope extends DebugInfo
    name: "CloseScope"

    closeScope: yes


@VariableDeclaration = class VariableDeclaration extends DebugInfo
    name: "VariableDeclaration"

    variableDeclaration: yes

@FunctionDefinition = class FunctionDefinition extends DebugInfo
    name: "FunctionDefinition"

    functionDefinition: yes