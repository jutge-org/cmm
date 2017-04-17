Error = require '../error'
{ Ast } = require './ast'
{ TYPES } = require './type'
{ Id } = require './id'
{ Variable } = require '../compiler/semantics/variable'

module.exports = @

@Declaration = class Declaration extends Ast
    getSpecifiers: ->
        [ specifiersList ] = @children

        specifiers = {}

        for specifier in specifiersList
            if typeof specifier is "string"
                name = specifier
                v = yes
            else
                name = "TYPE"
                v = specifier

            if specifiers[name]?
                throw Error.DUPLICATE_SPECIFIER.complete('specifier', name)
            else
                specifiers[name] = v

        unless specifiers.TYPE?
            throw Error.NO_TYPE_SPECIFIER
        else
            type = specifiers.TYPE
            delete specifiers.TYPE

        { specifiers, type }

    compile: (state) ->
        [ _, declarations ] = @children

        { specifiers, type } = @getSpecifiers()

        instructions = []

        for declaration in declarations
            if declaration instanceof Id
                { children: id } = declaration

                state.defineVariable(new Variable id, type, { specifiers })
            else # Is assign and has already been previously declared (ensured by grammar action)
                { instructions: declarationInstructions } = declaration.compile(state, { isFromDeclaration: yes })
                instructions = instructions.concat declarationInstructions

        return { type: TYPES.VOID, instructions }