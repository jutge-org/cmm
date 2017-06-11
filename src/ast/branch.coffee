{ Ast } = require './ast'

module.exports = @

@Branch = class Branch extends Ast
    name: "Branch"
    execute: (vm) ->
        [ jumpOffset ] = @children
        vm.pointers.instruction += jumpOffset

@BranchFalse = class BranchFalse extends Ast
    name: "BranchFalse"
    execute: (vm) ->
        [ conditionReference, jumpOffset ] = @children
        vm.pointers.instruction += jumpOffset unless conditionReference.read(vm.memory)

@BranchTrue = class BranchTrue extends Ast
    name: "BranchTrue"
    execute: (vm) ->
        [ conditionReference, jumpOffset ] = @children
        vm.pointers.instruction += jumpOffset if conditionReference.read(vm.memory)
