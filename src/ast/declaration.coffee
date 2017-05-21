Error = require '../error'
{ Ast } = require './ast'
{ PRIMITIVE_TYPES, Array, Pointer } = require './type'
{ Id } = require './id'
{ Variable } = require '../compiler/semantics/variable'
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

        if type is PRIMITIVE_TYPES.VOID
            throw Error.VOID_ARRAY_DECLARATION.complete('name', id)

        for dimension in dimensions[1..] when dimension is null
            throw Error.ALL_BOUNDS_EXCEPT_FIRST.complete('id', id)

        insideFunctionArgumentDefinitions = state.iAmInsideFunctionArgumentDefinitions()

        unless insideFunctionArgumentDefinitions or dimensions[0] isnt null
            throw Error.STORAGE_UNKNOWN.complete('id', id)

        arrayType = new Array(dimensions, type)

        if insideFunctionArgumentDefinitions
            state.defineVariable new Variable(id, new Pointer(arrayType.getElementType()))
        else
            state.defineVariable new Variable(id, arrayType, { specifiers })

        { instructions: [], id }

@IdDeclaration = class IdDeclaration extends Ast
    compile: (state, { specifiers, type }) ->
        [ idAst ] = @children

        { children: [ id ] } = idAst

        if type is PRIMITIVE_TYPES.VOID
            throw Error.VOID_DECLARATION.complete('name', id)

        state.defineVariable(new Variable id, type, { specifiers })

        { instructions: [], id }

@DeclarationAssign = class DeclarationAssign extends Ast
    compile: (state, { specifiers, type }) ->
        [ declaration, value ] = @children

        { id } = declaration.compile state, { specifiers, type }

        (new Assign(new Id(id), value)).compile(state, { isFromDeclaration: yes })



