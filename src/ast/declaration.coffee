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

    findId = (declarationAst) ->
        while declarationAst not instanceof IdDeclaration
            declarationAst = declarationAst.child()

        { children: [ { children: [ id ] } ] } = declarationAst

        id

    compile: (state) ->
        [ _, declarations ] = @children

        { specifiers, type } = @getSpecifiers()

        instructions = []

        for declaration in declarations
            { instructions: declarationInstructions } = declaration.compile(state, { specifiers, type, id: findId(declaration) })
            instructions = instructions.concat declarationInstructions

        return { type: PRIMITIVE_TYPES.VOID, instructions }

@ArrayDeclaration = class ArrayDeclaration extends Ast
    compile: (state, { specifiers, type, id }) ->
        [ innerDeclarationAst, dimension ] = @children

        if dimension < 0
            throw Error.ARRAY_SIZE_NEGATIVE.complete('id', id)

        if type is PRIMITIVE_TYPES.VOID
            throw Error.VOID_ARRAY_DECLARATION.complete('name', id)

        if type is PRIMITIVE_TYPES.STRING
            throw Error.STRING_ARRAY

        if type.isArray and not type.size?
            throw Error.ALL_BOUNDS_EXCEPT_FIRST.complete('id', id)

        type = new Array(dimension, type, { isValueConst: specifiers?.const or (type.isArray and type.isValueConst) })

        innerDeclarationAst.compile state, { type, id }

@IdDeclaration = class IdDeclaration extends Ast
    compile: (state, { specifiers, type, id }) ->
        if type is PRIMITIVE_TYPES.VOID
            throw Error.VOID_DECLARATION.complete('name', id)

        insideFunctionArgumentDefinitions = state.iAmInsideFunctionArgumentDefinitions()

        if type.isArray and not type.size? and not insideFunctionArgumentDefinitions
            throw Error.STORAGE_UNKNOWN.complete('id', id)

        if type.isArray and insideFunctionArgumentDefinitions
            state.defineVariable(new Variable id, new Pointer(type.getElementType()), { specifiers })
        else
            state.defineVariable(new Variable id, type, { specifiers })

        { instructions: [], id }

@PointerDeclaration = class PointerDeclaration extends Ast
    compile: (state, { specifiers, type, id }) ->
        if type is PRIMITIVE_TYPES.STRING
            throw Error.STRING_POINTER

        if type.isArray and not type.size? and state.iAmInsideFunctionArgumentDefinitions()
            throw Error.POINTER_UNBOUND_SIZE.complete("type", type.getSymbol(), "id", id)

        type = new Pointer type, { isValueConst: specifiers?.const }

        [ innerDeclarationAst ] = @children

        innerDeclarationAst.compile state, { type, id }


@ConstDeclaration = class ConstDeclaration extends Ast
    compile: (state, { type, id }) ->
        [ innerDeclarationAst ] = @children

        innerDeclarationAst.compile(state, { specifiers: { const: yes }, type, id })


@DeclarationAssign = class DeclarationAssign extends Ast
    compile: (state, { specifiers, type, id }) ->
        [ declaration, value ] = @children

        { id } = declaration.compile state, { specifiers, type, id }

        (new Assign(new Id(id), value)).compile(state, { isFromDeclaration: yes })