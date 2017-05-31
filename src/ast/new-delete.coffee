{ PRIMITIVE_TYPES } = require './type'
{ Ast } = require './ast'

module.exports = @

@New = class New extends Ast
    compile: (state) ->
        { type: PRIMITIVE_TYPES.INT, instructions: [], result: {} }


@NewArrayDeclaration = class NewArrayDeclaration extends Ast

@NewPointerDeclaration = class NewPointerDeclaration extends Ast

@NewDeclaration = class NewDeclaration extends Ast


@Delete = class Delete extends Ast
    compile: (state) ->
        { type: PRIMITIVE_TYPES.INT, instructions: [], result: {} }