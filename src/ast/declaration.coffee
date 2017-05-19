Error = require '../error'
{ Ast } = require './ast'
{ PRIMITIVE_TYPES, Array } = require './type'
{ Id } = require './id'
{ Variable } = require '../compiler/semantics/variable'
{ Initializer } = require './initializer'
{ Assign } = require './assign'

module.exports = @

@DeclarationGroup = class DeclarationGroup extends Ast
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
            { instructions: declarationInstructions } = declaration.compile(state, { specifiers, type })
            instructions = instructions.concat declarationInstructions

        return { type: PRIMITIVE_TYPES.VOID, instructions }

@ArrayDeclaration = class ArrayDeclaration extends Ast
    compile: (state, { specifiers, type }) ->
        [ { children: [ id ] }, dimensions ] = @children

        { isFunctionArgument } = state

        for dimension in dimensions[1..] when dimension is null
            throw Error.ALL_BOUNDS_EXCEPT_FIRST.complete('id', id)

        unless isFunctionArgument or dimensions[0] isnt null
            throw Error.STORAGE_UNKNOWN.complete('id', id)

        state.defineVariable new Variable(id, new Array(dimensions, type), { specifiers })

        { instructions: [], id }

@IdDeclaration = class IdDeclaration extends Ast
    compile: (state, { specifiers, type }) ->
        [ idAst ] = @children

        { children: [ id ] } = idAst

        state.defineVariable(new Variable id, type, { specifiers })

        { instructions: [], id }

@DeclarationAssign = class DeclarationAssign extends Ast
    compile: (state, { specifiers, type }) ->
        [ declaration, value ] = @children

        { id } = declaration.compile state, { specifiers, type }

        if value instanceof Initializer
            value.compile(state, { id })
        else
            (new Assign(new Id(id), value)).compile(state, { isFromDeclaration: yes })



