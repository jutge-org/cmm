{ Ast } = require './ast'
{ PRIMITIVE_TYPES, EXPR_TYPES } = require './type'
{ Read } = require './read'
{ BranchFalse } = require './branch'

module.exports = @

@Cin = class Cin extends Ast
    name: "Cin"
    compile: (state) ->
        instructions = []
        result = state.getTemporary PRIMITIVE_TYPES.BOOL

        for destAst, i in @children
            { exprType, type, result: memoryReference, lvalueId, instructions: destInstructions, isConst } = destAst.compile state

            unless type in [PRIMITIVE_TYPES.STRING, PRIMITIVE_TYPES.INT, PRIMITIVE_TYPES.DOUBLE, PRIMITIVE_TYPES.CHAR, PRIMITIVE_TYPES.BOOL]
                destAst.compilationError 'INVALID_CIN_OPERAND', 'type', type.getSymbol()

            unless exprType is EXPR_TYPES.LVALUE
                destAst.compilationError 'LVALUE_CIN'

            if isConst
                destAst.compilationError 'CONST_MODIFICATION', "name", lvalueId

            state.releaseTemporaries memoryReference

            instructions = instructions.concat([ destInstructions..., new Read result, memoryReference ])

            if i isnt @children.length - 1
                jumpOffset = @children.length - i - 1
                instructions.push(new BranchFalse result, +jumpOffset)

            # Add read instruction with variable's reference cin (tmp with bool, same for all cin's), (id reference)
            # Add goto end if tmp is false and it's not the last cin
            # Its result is the bool tmp

        instructions.forEach((x) => x.locations = @locations)

        return { type: PRIMITIVE_TYPES.CIN, result, instructions, exprType: EXPR_TYPES.RVALUE }
