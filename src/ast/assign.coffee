{ Ast } = require './ast'
{ ensureType } = require './type'
Error = require '../error'

module.exports = @

@Assign = class Assign extends Ast
    compile: (state) ->
        [ variableAst, valueAst ] = @children
        { children: [ variable ] } = variableAst

        { type: variableType, result: variableReference } = variableAst.compile state
        { type: valueType, instructions: valueInstructions, result: valueReference } = valueAst.compile state

        unless variableType.isAssignable
            throw Error.ASSIGN_OF_NON_ASSIGNABLE.complete('variableName', variable, 'type', variableType.id)

        { instructions: castInstructions, result } = ensureType valueReference, valueType, variableType, state

        state.releaseTemporaries result

        instructions = [ valueInstructions..., castInstructions..., new Assign(variableReference, result) ]

        instructions.forEach((x) => x.locations = @locations)

        return {
            type: variableType
            instructions
            result: variableReference
        }

    execute: ({ memory }) ->
        [ dest, src ] = @children
        dest.write(memory, src.read(memory))