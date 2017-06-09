{ Ast } = require './ast'
{ PRIMITIVE_TYPES, EXPR_TYPES } = require './type'
{ Add, Sub, Mul, Div, Mod } = require './binary-op'
{ IntLit } = require './literals'
{ Assign } = require './assign'
{ compilationError } = require '../messages'
utils = require '../utils'

module.exports = @

class PreOp extends Ast
    compile: (state) ->
        [ destAst ] = @children

        resultAst = destAst.compile state

        @checkType?(resultAst.type)

        resultAstAdd = utils.clone resultAst
        resultAstAdd.instructions = []

        (new Assign({ compile: -> resultAst }, new Add({ compile: -> resultAstAdd }, new IntLit(@incr)))).compile(state)

@PreInc = class PreInc extends PreOp
    incr: "1"

@PreDec = class PreDec extends PreOp
    incr: "-1"

    checkType: (type) ->
        if type is PRIMITIVE_TYPES.BOOL
            compilationError 'INVALID_BOOL_DEC'


class PostOp extends Ast
    compile: (state) ->
        [ destAst ] = @children

        resultAst = destAst.compile state

        @checkType?(resultAst.type)

        result = state.getTemporary resultAst.type

        resultAstAdd = utils.clone resultAst
        resultAstAdd.instructions = []

        { instructions: assignInstructions, result: assignResult } = (new Assign({ compile: -> resultAst }, new Add({ compile: -> resultAstAdd }, new IntLit(@incr)))).compile(state)

        state.releaseTemporaries assignResult

        { instructions: [ new Assign(result, resultAst.result), assignInstructions... ], result, type: resultAst.type, exprType: EXPR_TYPES.RVALUE }

@PostInc = class PostInc extends PostOp
    incr: "1"

@PostDec = class PostDec extends PostOp
    incr: "-1"

    checkType: (type) ->
        if type is PRIMITIVE_TYPES.BOOL
            compilationError 'INVALID_BOOL_DEC'


class OpAssign extends Ast
    compile: (state) ->
        [ destAst, valueAst ] = @children

        result = destAst.compile state
        resultOp = utils.clone result
        resultOp.instructions = []

        (new Assign({ compile: -> result }, new @op({ compile: -> resultOp }, valueAst))).compile(state)

@AddAssign = class AddAssign extends OpAssign
    op: Add
@SubAssign = class SubAssign extends OpAssign
    op: Sub
@MulAssign = class MulAssign extends OpAssign
    op: Mul
@DivAssign = class DivAssign extends OpAssign
    op: Div
@ModAssign = class ModAssign extends OpAssign
    op: Mod