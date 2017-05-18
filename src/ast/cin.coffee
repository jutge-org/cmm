{ Ast } = require './ast'
{ BASIC_TYPES, EXPR_TYPES } = require './type'
Error = require '../error'
{ Read } = require './read'
{ BranchFalse } = require './branch'

module.exports = @

@Cin = class Cin extends Ast
    compile: (state) ->
        instructions = []
        result = state.getTemporary BASIC_TYPES.BOOL

        for idAst, i in @children
            id = idAst.child()

            # Comprovar que tots els fills son ids i que tenen tipus assignable
            # retorna cin

            variable = state.getVariable id

            unless variable?
                throw Error.CIN_VARIABLE_UNDEFINED.complete('name', id)

            if variable.specifiers.const
                throw Error.CONST_MODIFICATION.complete("name", variable.id)

            { type, memoryReference } = variable

            unless type.isAssignable
                throw Error.CIN_OF_NON_ASSIGNABLE

            instructions = instructions.concat(new Read result, memoryReference)

            if i isnt @children.length - 1
                jumpOffset = @children.length - i - 1
                instructions = instructions.concat(new BranchFalse result, +jumpOffset)

            # Add read instruction with variable's reference cin (tmp with bool, same for all cin's), (id reference)
            # Add goto end if tmp is false and it's not the last cin
            # Its result is the bool tmp

        instructions.forEach((x) => x.locations = @locations)

        return { type: BASIC_TYPES.CIN, result, instructions, exprType: EXPR_TYPES.RVALUE }