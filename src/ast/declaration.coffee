Error = require '../error'
{ Ast } = require './ast'
{ PRIMITIVE_TYPES, Array, Pointer, Reference, FunctionType } = require './type'
{ Id } = require './id'
{ Variable } = require '../compiler/semantics/variable'
{ FunctionVar } = require '../compiler/semantics/function-var'
{ Assign } = require './assign'

module.exports = @

@getSpecifiers = getSpecifiers = (specifiersList) ->
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

@DeclarationGroup = class DeclarationGroup extends Ast
    getSpecifiers: -> getSpecifiers @children[0]

    findId = (declarationAst) ->
        # Here typedeclaration is for new expressions
        until declarationAst instanceof IdDeclaration
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

@IdDeclaration = class IdDeclaration extends Ast
    compile: (state, { specifiers, type, id }) ->
        isReturnDefinition = state.iAmInsideFunctionReturnDefinition()

        if not isReturnDefinition and type is PRIMITIVE_TYPES.VOID
            throw Error.VOID_DECLARATION.complete('name', id)

        insideFunctionArgumentDefinitions = state.iAmInsideFunctionArgumentDefinitions()

        if type.isArray and not type.size? and not insideFunctionArgumentDefinitions
            throw Error.STORAGE_UNKNOWN.complete('id', id)

        if type.isArray and insideFunctionArgumentDefinitions
            state.defineVariable(new Variable id, new Pointer(type.getElementType()), { specifiers })
        else if isReturnDefinition
            state.newFunction(new FunctionVar(id, new FunctionType(type)))
        else
            state.defineVariable(new Variable id, type, { specifiers })

        { instructions: [], id }

@ArrayDeclaration = class ArrayDeclaration extends Ast
    compile: (state, { specifiers, type, id }) ->
        [ innerDeclarationAst, dimensionAst ] = @children

        if state.iAmInsideFunctionReturnDefinition()
            throw Error.ARRAY_OF_FUNCTION.complete('id', id)

        if dimensionAst?
            { staticValue: dimension, type: dimensionType } = dimensionAst.compile state

            unless dimension?
                throw Error.STATIC_SIZE_ARRAY.complete('id', id)

            unless dimensionType.isIntegral
                throw Error.NONINTEGRAL_DIMENSION.complete('type', dimensionType.getSymbol(), 'id', id)

            if dimension < 0
                throw Error.ARRAY_SIZE_NEGATIVE.complete('id', id)

        if type is PRIMITIVE_TYPES.VOID or type.isReference
            throw Error.ARRAY_DECLARATION.complete('name', id, 'type', type.getSymbol())

        if type is PRIMITIVE_TYPES.STRING
            throw Error.STRING_ARRAY

        if type.isArray and not type.size?
            throw Error.ALL_BOUNDS_EXCEPT_FIRST.complete('id', id)

        # TODO: Should check that the size is below the implementation limit
        type = new Array(dimension, type, { isValueConst: specifiers?.const or (type.isArray and type.isValueConst) })

        innerDeclarationAst.compile state, { type, id }


@PointerDeclaration = class PointerDeclaration extends Ast
    compile: (state, { specifiers, type, id }) ->
        if type is PRIMITIVE_TYPES.STRING
            throw Error.STRING_POINTER

        if type.isArray and not type.size? and state.iAmInsideFunctionArgumentDefinitions()
            throw Error.POINTER_UNBOUND_SIZE.complete("type", type.getSymbol(), "id", id)

        if type.isReference
            throw Error.POINTER_TO.complete("type", type.getSymbol(), "id", id)

        type = new Pointer type, { isValueConst: specifiers?.const }

        [ innerDeclarationAst ] = @children

        innerDeclarationAst.compile state, { type, id }

@ReferenceDeclaration = class ReferenceDeclaration extends Ast
    compile: (state, { type, id, specifiers, isInitialized }) ->
        if type is PRIMITIVE_TYPES.STRING
            throw Error.STRING_ADDRESSING

        if type is PRIMITIVE_TYPES.VOID or type.isReference
            throw Error.REFERENCE_TO.complete('type', type.getSymbol(), "id", id)

        unless state.iAmInsideFunctionArgumentDefinitions() or state.iAmInsideFunctionReturnDefinition() or isInitialized
            throw Error.UNINITIALIZED_REFERENCE.complete('id', id)

        type = new Reference type, { isValueConst: specifiers?.const }

        [ innerDeclarationAst ] = @children

        innerDeclarationAst.compile state, { type, id }



@ConstDeclaration = class ConstDeclaration extends Ast
    compile: (state, { type, id }) ->
        [ innerDeclarationAst ] = @children

        innerDeclarationAst.compile(state, { specifiers: { const: yes }, type, id })


@DeclarationAssign = class DeclarationAssign extends Ast
    compile: (state, { specifiers, type, id }) ->
        [ declaration, value ] = @children

        { id } = declaration.compile state, { specifiers, type, id, isInitialized: yes }

        (new Assign(new Id(id), value)).compile(state, { isFromDeclaration: yes })