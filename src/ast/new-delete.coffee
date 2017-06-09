{ PRIMITIVE_TYPES, Pointer, Array } = require './type'
{ Ast } = require './ast'
{ getSpecifiers } = require './declaration'
{ executionError } = require '../messages'

module.exports = @

@Delete = class Delete extends Ast
    compile: (state) ->
        [ maybeArr, pointerAst ] = @children

        if maybeArr is "[" # TODO: Check on future extension whether there is a need to distinguish between delete[] and delete, currently they have the same behaviour
            isArray = yes
        else
            isArray = no
            pointerAst = maybeArr

        { instructions, result, type } = pointerAst.compile state

        state.releaseTemporaries result

        unless type.isPointer or type.isArray
            @compilationError 'INVALID_DELETE_TYPE', "type", type.getSymbol()

        { type: PRIMITIVE_TYPES.VOID, instructions: [ instructions..., new Delete(result) ]}

    execute: (vm) ->
        [ pointerReference ] = @children

        value = pointerReference.read(vm.memory)

        unless value is 0 # If value is 0 it is a null pointer
            vm.free(value)

@New = class New extends Ast
    compile: (state) ->
        [ specifiersList, declarationAst ] =  @children

        { type, specifiers } = getSpecifiers(specifiersList)

        if type is PRIMITIVE_TYPES.STRING
            @compilationError 'STRING_ADDRESSING'

        if type is PRIMITIVE_TYPES.VOID
            @compilationError 'VOID_INVALID_USE'

        { instructions: declarationInstructions, type, dimensionResult } = declarationAst.compile state, { specifiers, type }

        type =
            if type.isArray
                maybeStaticDimension = type.size
                new Pointer(type.getElementType(), { specifiers: {} })
            else
                new Pointer(type, { specifiers: {} })

        result = state.getTemporary type

        { instructions: [ declarationInstructions..., new New(result, maybeStaticDimension ? null, dimensionResult ? null) ], type, result }

    execute: (vm) ->
        { memory } = vm
        # TODO: Implement
        # TODO: Check whether there's memory left
        [ resultReference, dimension ] = @children

        type = resultReference.getType().getElementType() # It's a pointer

        reserve = type.bytes
        if dimension?
            elements =
                if isNaN(dimension) # Dynamic dimension
                    dimension.read(memory)
                else # Static dimension
                    dimension

            if elements < 0
                executionError vm, 'INVALID_NEW_ARRAY_LENGTH'
                return

            reserve *= elements

        address = vm.alloc(reserve)

        resultReference.write(memory, address)


@NewArrayDeclaration = class NewArrayDeclaration extends Ast
    compile: (state, { type, specifiers, parentAstDimension }) ->
        [ innerDeclarationAst, dimensionAst ] = @children

        { staticValue: dimension, type: dimensionType, result: dimensionResult, instructions: dimensionInstructions } =
            dimensionAst.compile state

        unless dimensionType.isIntegral
            dimensionAst.compilationError 'NONINTEGRAL_DIMENSION'

        if type.isArray and not type.size?
            parentAstDimension.compilationError 'NEW_ARRAY_SIZE_CONSTANT'

        if dimension? # Is static dimension
            if dimension < 0
                dimensionAst.compilationError 'ARRAY_SIZE_NEGATIVE'
        else # Dynamic dimension
            state.releaseTemporaries dimensionResult

        type = new Array(dimension, type, { isValueConst: specifiers?.const })

        { instructions: innerInstructions, dimensionResult: secondDimensionResult, type } = innerDeclarationAst.compile(state, { type, specifiers: { const: type.isValueConst }, parentAstDimension: dimensionAst })

        { type, instructions: [ dimensionInstructions..., innerInstructions... ], dimensionResult: if dimension? then secondDimensionResult else dimensionResult }


@NewPointerDeclaration = class NewPointerDeclaration extends Ast
    compile: (state, { specifiers, type }) ->
        [ innerDeclarationAst ] = @children

        type = new Pointer type, { isValueConst: specifiers?.const }

        innerDeclarationAst.compile state, { type }

@NewDeclaration = class NewDeclaration extends Ast
    compile: (state, { specifiers, type }) ->
        if specifiers?.const
            @compilationError 'UNINITIALIZED_CONST_NEW'

        { instructions: [], type }
