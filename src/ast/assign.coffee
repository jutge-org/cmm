{ Ast } = require './ast'
{ ensureType, EXPR_TYPES, Array, PRIMITIVE_TYPES } = require './type'
Error = require '../error'

module.exports = @

@Assign = class Assign extends Ast
    compile: (state, { isFromDeclaration = no } = {}) ->
        [ destAst, valueAst ] = @children

        { type: valueType, instructions: valueInstructions, result: valueReference } = valueAst.compile state

        { type: destType, result: destReference, exprType, lvalueId, instructions: destInstructions } = destAst.compile state

        { instructions: castInstructions, result } = ensureType valueReference, valueType, destType, state, { onReference: destReference }

        state.releaseTemporaries destReference

        state.releaseTemporaries result

        unless exprType is EXPR_TYPES.LVALUE
            throw Error.LVALUE_ASSIGN

        unless destType.isAssignable # HACK: Assumes that every lvalue expression returns a lvalueId, which may not be true for expressions such as *(a + 2) = 3, a being a pointer
            throw Error.ASSIGN_OF_NON_ASSIGNABLE.complete('variableName', lvalueId, 'type', destType.id)

        if destType instanceof Array
            throw Error.ASSIGN_TO_ARRAY

        variable = state.getVariable lvalueId

        if not isFromDeclaration and variable.specifiers.const
            throw Error.CONST_MODIFICATION.complete("name", variable.id)

        instructions = [ valueInstructions..., destInstructions..., castInstructions... ]

        unless castInstructions.length
            instructions.push new Assign(destReference, result)

        instructions.forEach((x) => x.locations = @locations)

        return {
            type: destType
            instructions
            result: destReference
            exprType: EXPR_TYPES.RVALUE
        }

    execute: ({ memory }) ->
        [ dest, src ] = @children
        dest.write(memory, src.read(memory))


