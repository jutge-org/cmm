{ Ast } = require './ast'
{ BASIC_TYPES } = require './type'
{ Add } = require './binary-op'
{ IntLit } = require './literals'
{ Assign } = require './assign'

module.exports = @

class PreOp extends Ast
    compile: (state) ->
        [ destAst ] = @children

        { type: destType, result: destReference, exprType, lvalueId } = destAst.compile state

        @checkType?(destType)

        (new Assign(destAst, new Add(destAst, new IntLit(@incr)))).compile(state)

@PreInc = class PreInc extends PreOp
    incr: "1"

@PreDec = class PreDec extends PreOp
    incr: "-1"

    checkType: (type) ->
        if type is BASIC_TYPES.BOOL
            throw Error.INVALID_BOOL_DEC


class PostOp extends Ast
    compile: (state) ->
        [ destAst ] = @children

        { type: destType, result: destReference } = destAst.compile state

        @checkType?(destType)

        result = state.getTemporary destType

        { instructions: assignInstructions, result: assignResult } = (new Assign(destAst, new Add(destAst, new IntLit(@incr)))).compile(state)

        state.releaseTemporaries assignResult

        { instructions: [ new Assign(result, destReference), assignInstructions... ], result, type: destType }

@PostInc = class PostInc extends PostOp
    incr: "1"

@PostDec = class PostDec extends PostOp
    incr: "-1"

    checkType: (type) ->
        if type is BASIC_TYPES.BOOL
            throw Error.INVALID_BOOL_DEC