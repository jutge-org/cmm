{ Ast } = require './ast'
{ ensureType, EXPR_TYPES, Array, PRIMITIVE_TYPES } = require './type'
{ compilationError } = require '../messages'

module.exports = @

@Assign = class Assign extends Ast
    compile: (state, { isFromDeclaration = no } = {}) ->
        [ destAst, valueAst ] = @children

        { type: destType, result: destReference, exprType, lvalueId, instructions: destInstructions, isConst } = destAst.compile state

        if destType instanceof Array
            compilationError 'ASSIGN_TO_ARRAY'

        unless destType.isAssignable # HACK: Assumes that every lvalue expression returns a lvalueId, which may not be true for expressions such as *(a + 2) = 3, a being a pointer
            compilationError 'ASSIGN_OF_NON_ASSIGNABLE', 'id', lvalueId, 'type', destType.getSymbol()

        { type: valueType, instructions: valueInstructions, result: valueReference } = valueAst.compile state

        if valueType is PRIMITIVE_TYPES.VOID
            compilationError 'VOID_NOT_IGNORED'

        { instructions: castInstructions, result } = ensureType valueReference, valueType, destType, state, { onReference: destReference, releaseReference: no }

        unless exprType is EXPR_TYPES.LVALUE
            compilationError 'LVALUE_ASSIGN'

        if not isFromDeclaration and isConst
            compilationError 'CONST_MODIFICATION', "name", lvalueId

        state.releaseTemporaries valueReference

        instructions = [ destInstructions..., valueInstructions..., castInstructions... ]

        unless castInstructions.length
            instructions.push new Assign(destReference, result)

        instructions.forEach((x) => x.locations = @locations)

        return {
            type: destType
            instructions
            result: destReference
            exprType: EXPR_TYPES.LVALUE
            lvalueId: null
        }

    execute: ({ memory }) ->
        [ dest, src ] = @children
        dest.write(memory, src.read(memory))



