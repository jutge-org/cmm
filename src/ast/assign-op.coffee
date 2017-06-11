{ Ast } = require './ast'
{ PRIMITIVE_TYPES, EXPR_TYPES } = require './type'
{ Add, Sub, Mul, Div, Mod } = require './binary-op'
{ IntLit } = require './literals'
{ Assign } = require './assign'
utils = require '../utils'

module.exports = @

class PreOp extends Ast
    compile: (state) ->
        [ destAst ] = @children

        resultAst = destAst.compile state

        @checkType?(resultAst.type)

        resultAstAdd = utils.clone resultAst
        resultAstAdd.instructions = []

        intLitAst = new IntLit(@incr)
        intLitAst.locations = @locations

        addAst = new Add({ compile: -> resultAstAdd }, intLitAst)
        addAst.locations = @locations

        assignAst = new Assign({ compile: -> resultAst }, addAst)
        assignAst.locations = @locations

        assignAst.compile(state)

@PreInc = class PreInc extends PreOp
    name: "PreInc"
    incr: "1"

@PreDec = class  PreDec extends PreOp
    name: "PreDec"
    incr: "-1"

    checkType: (type) ->
        if type is PRIMITIVE_TYPES.BOOL
            @compilationError 'INVALID_BOOL_DEC'


class PostOp extends Ast
    compile: (state) ->
        [ destAst ] = @children

        resultAst = destAst.compile state

        @checkType?(resultAst.type)

        result = state.getTemporary resultAst.type

        resultAstAdd = utils.clone resultAst
        resultAstAdd.instructions = []

        intLitAst = new IntLit(@incr)
        intLitAst.locations = @locations

        addAst = new Add({ compile: -> resultAstAdd }, intLitAst)
        addAst.locations = @locations

        assignAst = new Assign({ compile: -> resultAst }, addAst)
        assignAst.locations = @locations

        { instructions: assignInstructions, result: assignResult } = assignAst.compile(state)

        state.releaseTemporaries assignResult

        { instructions: [ new Assign(result, resultAst.result), assignInstructions... ], result, type: resultAst.type, exprType: EXPR_TYPES.RVALUE }

@PostInc = class PostInc extends PostOp
    name: "PostInc"
    incr: "1"

@PostDec = class PostDec extends PostOp
    name: "PostDec"
    incr: "-1"

    checkType: (type) ->
        if type is PRIMITIVE_TYPES.BOOL
            @compilationError 'INVALID_BOOL_DEC'


class OpAssign extends Ast
    compile: (state) ->
        [ destAst, valueAst ] = @children

        result = destAst.compile state
        resultOp = utils.clone result
        resultOp.instructions = []


        opAst = new @op({ compile: -> resultOp }, valueAst)
        opAst.locations = @locations

        assignAst = new Assign({ compile: -> result }, opAst)
        assignAst.locations = @locations

        assignAst.compile(state)

@AddAssign = class AddAssign extends OpAssign
    name: "AddAssign"
    op: Add
@SubAssign = class SubAssign extends OpAssign
    name: "SubAssign"
    op: Sub
@MulAssign = class MulAssign extends OpAssign
    name: "MulAssign"
    op: Mul
@DivAssign = class DivAssign extends OpAssign
    name: "DivAssign"
    op: Div
@ModAssign = class ModAssign extends OpAssign
    name: "ModAssign"
    op: Mod
