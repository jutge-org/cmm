{ Ast } = require './ast'
{ TYPES } = require './type'
{ Id } = require './id'
{ Variable } = require '../compiler/semantics/variable'

module.exports = @

@Declaration = class Declaration extends Ast
    compile: (state) ->
        [ type, declarations ] = @children

        instructions = []

        for declaration in declarations
            if declaration instanceof Id
                { children: id } = declaration

                state.defineVariable(new Variable id, type)
            else # Is assign and has already been previously declared (ensured by grammar action)
                { instructions: declarationInstructions } = declaration.compile(state)
                instructions = instructions.concat declarationInstructions

        return { type: TYPES.VOID, instructions }

#return { type, variable, instructions }