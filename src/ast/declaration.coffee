{ Ast } = require './ast'
{ PRIMITIVE_TYPES, Array, Pointer, Reference, FunctionType } = require './type'
{ Id } = require './id'
{ Variable } = require '../compiler/semantics/variable'
{ FunctionVar } = require '../compiler/semantics/function-var'
{ Assign } = require './assign'
{ compilationError } = require '../messages'

module.exports = @

@getSpecifiers = getSpecifiers = (specifiersList, state) ->
    specifiers = {}

    for specifier in specifiersList
        if typeof specifier is "string"
            name = specifier
            v = yes
        else
            name = "TYPE"
            v = specifier

        if specifiers[name]?
            compilationError 'DUPLICATE_SPECIFIER', 'specifier', name
        else
            specifiers[name] = v

    unless specifiers.TYPE?
        if state?.iAmInsideFunctionReturnDefinition()
            compilationError 'NO_RETURN_TYPE'
        else
            compilationError 'NO_TYPE_SPECIFIER'

    else
        type = specifiers.TYPE
        delete specifiers.TYPE

    { specifiers, type }

@DeclarationGroup = class DeclarationGroup extends Ast
    getSpecifiers: (id, state) -> getSpecifiers @children[0], id, state

    findId = (declarationAst) ->
        # Here typedeclaration is for new expressions
        until declarationAst instanceof IdDeclaration
            declarationAst = declarationAst.child()

        { children: [ { children: [ id ] } ] } = declarationAst

        id

    compile: (state) ->
        [ _, declarations ] = @children

        { specifiers, type } = @getSpecifiers(state)

        instructions = []

        for declaration in declarations
            { instructions: declarationInstructions } = declaration.compile(state, { specifiers, type, id: findId(declaration) })
            instructions = instructions.concat declarationInstructions

        return { type: PRIMITIVE_TYPES.VOID, instructions }

@IdDeclaration = class IdDeclaration extends Ast
    compile: (state, { specifiers, type, id }) ->
        isReturnDefinition = state.iAmInsideFunctionReturnDefinition()
        insideFunctionArgumentDefinitions = state.iAmInsideFunctionArgumentDefinitions()

        if not isReturnDefinition and type is PRIMITIVE_TYPES.VOID
            if insideFunctionArgumentDefinitions
                compilationError 'VOID_FUNCTION_ARGUMENT', 'argument', id, 'function', state.functionId
            else
                compilationError 'VOID_DECLARATION', 'name', id



        if type.isArray and not type.size? and not insideFunctionArgumentDefinitions
            compilationError 'STORAGE_UNKNOWN', 'id', id

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
            compilationError 'ARRAY_OF_FUNCTIONS', 'id', id

        if dimensionAst?
            { staticValue: dimension, type: dimensionType } = dimensionAst.compile state

            unless dimension?
                compilationError 'STATIC_SIZE_ARRAY', 'id', id

            unless dimensionType.isIntegral
                compilationError 'NONINTEGRAL_DIMENSION', 'type', dimensionType.getSymbol(), 'id', id

            if dimension < 0
                compilationError 'ARRAY_SIZE_NEGATIVE', 'id', id

        if type is PRIMITIVE_TYPES.VOID
            compilationError 'INVALID_ARRAY_DECLARATION_TYPE', 'name', id, 'type', type.getSymbol()

        if type is PRIMITIVE_TYPES.STRING
            compilationError 'STRING_ARRAY'

        if type.isArray and not type.size?
            compilationError 'ALL_BOUNDS_EXCEPT_FIRST', 'id', id

        # TODO: Should check that the size is below the implementation limit
        type = new Array(dimension, type, { isValueConst: specifiers?.const or (type.isArray and type.isValueConst) })

        innerDeclarationAst.compile state, { type, id }


@PointerDeclaration = class PointerDeclaration extends Ast
    compile: (state, { specifiers, type, id }) ->
        if type is PRIMITIVE_TYPES.STRING
            compilationError 'STRING_POINTER'

        if type.isArray and not type.size? and state.iAmInsideFunctionArgumentDefinitions()
            compilationError 'POINTER_UNBOUND_SIZE', "type", type.getSymbol(), "id", id

        type = new Pointer type, { isValueConst: specifiers?.const }

        [ innerDeclarationAst ] = @children

        innerDeclarationAst.compile state, { type, id }

@ReferenceDeclaration = class ReferenceDeclaration extends Ast
    compile: (state, { type, id, specifiers, isInitialized }) ->
        if type is PRIMITIVE_TYPES.STRING
            compilationError 'STRING_ADDRESSING'

        if type is PRIMITIVE_TYPES.VOID or type.isReference
            compilationError 'REFERENCE_TO', 'type', type.getSymbol(), "id", id

        unless state.iAmInsideFunctionArgumentDefinitions() or state.iAmInsideFunctionReturnDefinition() or isInitialized
            compilationError 'UNINITIALIZED_REFERENCE', 'id', id

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