{ Ast } = require './ast'

module.exports = @

@Branch = class Branch extends Ast
    # [ jumpOffset ] = @children

@BranchFalse = class BranchFalse extends Ast
    # [ conditionReference, jumpOffset ] = @children

@BranchTrue = class BranchTrue extends Ast
    # [ conditionReference, jumpOffset ] = @children