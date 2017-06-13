{ Ast } = require './ast'
{ PRIMITIVE_TYPES, Array, Pointer, Reference, FunctionType } = require './type'
{ Id } = require './id'
{ Variable } = require '../compiler/semantics/variable'
{ FunctionVar } = require '../compiler/semantics/function-var'
{ Assign } = require './assign'
{ VariableDeclaration } = require './debug-info'

module.exports = @

@EmptyDimension = class EmptyDimension extends Ast
    name: "EmptyDimension"
    isEmptyDimension: yes

@getSpecifiers = getSpecifiers = (specifiersList, state, ast) ->
    specifiers = {}

    for specifier in specifiersList
        if typeof specifier is "string"
            name = specifier
            v = yes
        else
            name = "TYPE"
            v = specifier

        if specifiers[name]?
            ast.compilationError 'DUPLICATE_SPECIFIER', 'specifier', name
        else
            specifiers[name] = v

    unless specifiers.TYPE?
        if state?.iAmInsideFunctionReturnDefinition()
            ast.compilationError 'NO_RETURN_TYPE'
        else
            ast.compilationError 'NO_TYPE_SPECIFIER'

    else
        type = specifiers.TYPE
        delete specifiers.TYPE

    { specifiers, type }

@DeclarationGroup = class DeclarationGroup extends Ast
    name: "DeclarationGroup"
    getSpecifiers: (state) -> getSpecifiers @children[0], state, this

    findId = (declarationAst) ->
        # Here typedeclaration is for new expressions
        until declarationAst instanceof IdDeclaration
            declarationAst = declarationAst.child()

        { children: [ { children: [ id ] } ] } = declarationAst

        { id, idAst: declarationAst }

    compile: (state) ->
        [ _, declarations ] = @children

        { specifiers, type } = @getSpecifiers(state)

        instructions = []

        for declaration in declarations
            { id, idAst } = findId(declaration)
            { instructions: declarationInstructions } = declaration.compile(state, { specifiers, type, id, idAst })
            instructions = instructions.concat declarationInstructions

        return { type: PRIMITIVE_TYPES.VOID, instructions }

@IdDeclaration = class IdDeclaration extends Ast
    name: "IdDeclaration"
    compile: (state, { specifiers, type, id, idAst }) ->
        isReturnDefinition = state.iAmInsideFunctionReturnDefinition()
        insideFunctionArgumentDefinitions = state.iAmInsideFunctionArgumentDefinitions()

        if not isReturnDefinition and type is PRIMITIVE_TYPES.VOID
            if insideFunctionArgumentDefinitions
                @compilationError 'VOID_FUNCTION_ARGUMENT', 'argument', id, 'function', state.functionId
            else
                @compilationError 'VOID_DECLARATION', 'name', id



        if type.isArray and not type.size? and not insideFunctionArgumentDefinitions
            @compilationError 'STORAGE_UNKNOWN', 'id', id

        variable =
            if type.isArray and insideFunctionArgumentDefinitions
                state.defineVariable(new Variable(id, new Pointer(type.getElementType()), { specifiers }), idAst)
            else if isReturnDefinition
                state.newFunction(new FunctionVar(id, new FunctionType(type)), idAst)
                null
            else
                state.defineVariable(new Variable(id, type, { specifiers }), idAst)

        { instructions: (if variable? then [ new VariableDeclaration(variable) ] else []), id }

@ArrayDeclaration = class ArrayDeclaration extends Ast
    name: "ArrayDeclaration"
    compile: (state, { specifiers, type, id, idAst, parentDimensionAst }) ->
        [ innerDeclarationAst, dimensionAst ] = @children

        if state.iAmInsideFunctionReturnDefinition()
            @compilationError 'ARRAY_OF_FUNCTIONS', 'id', id

        unless dimensionAst.isEmptyDimension
            { staticValue: dimension, type: dimensionType } = dimensionAst.compile state

            unless dimension?
                dimensionAst.compilationError 'STATIC_SIZE_ARRAY', 'id', id

            unless dimensionType.isIntegral
                dimensionAst.compilationError 'NONINTEGRAL_DIMENSION', 'type', dimensionType.getSymbol(), 'id', id

            if dimension < 0
                dimensionAst.compilationError 'ARRAY_SIZE_NEGATIVE', 'id', id

        if type is PRIMITIVE_TYPES.VOID
            @compilationError 'INVALID_ARRAY_DECLARATION_TYPE', 'name', id, 'type', type.getSymbol()

        if type is PRIMITIVE_TYPES.STRING
            @compilationError 'STRING_ARRAY'

        if type.isArray and not type.size?
            parentDimensionAst.compilationError 'ALL_BOUNDS_EXCEPT_FIRST', 'id', id

        # TODO: Should check that the size is below the implementation limit
        type = new Array(dimension, type, { isValueConst: specifiers?.const or (type.isArray and type.isValueConst) })

        innerDeclarationAst.compile state, { type, id, idAst, parentDimensionAst: dimensionAst }


@PointerDeclaration = class PointerDeclaration extends Ast
    name: "PointerDeclaration"
    compile: (state, { specifiers, type, id, idAst }) ->
        if type is PRIMITIVE_TYPES.STRING
            @compilationError 'STRING_POINTER'

        if type.isArray and not type.size? and state.iAmInsideFunctionArgumentDefinitions()
            @compilationError 'POINTER_UNBOUND_SIZE', "type", type.getSymbol(), "id", id

        type = new Pointer type, { isValueConst: specifiers?.const }

        [ innerDeclarationAst ] = @children

        innerDeclarationAst.compile state, { type, id, idAst }

@ConstDeclaration = class ConstDeclaration extends Ast
    name: "PointerDeclaration"
    compile: (state, { type, id, idAst }) ->
        [ innerDeclarationAst ] = @children

        innerDeclarationAst.compile(state, { specifiers: { const: yes }, type, id, idAst })


@DeclarationAssign = class DeclarationAssign extends Ast
    name: "DeclarationAssign"
    compile: (state, { specifiers, type, id, idAst }) ->
        [ declaration, value ] = @children

        { id } = declaration.compile state, { specifiers, type, id, isInitialized: yes, idAst }

        innerIdAst = new Id(id)
        innerIdAst.locations = idAst.locations

        assignAst = new Assign(innerIdAst, value)
        assignAst.locations = @locations

        assignAst.compile(state, { isFromDeclaration: yes })
