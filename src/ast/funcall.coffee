{ Ast } = require './ast'
{ TYPES, ensureType } = require './type'
Error = require '../error'
{ ReturnReference } = require './memory-reference'

module.exports = @

@Funcall = class Funcall extends Ast
    compile: (state) ->
        console.log "Funcall"

        [ { children: [ funcId ] }, paramList ] = @children

        # Comprovar que la variable cridada esta definida
        # Comprovar que el id que s'està cridant té realment tipus funció
        # Comprovar/castejar que tots els paràmetres de la crida tenen el tipus que toca
        # Retorna el tipus de la funció

        func = state.getVariable funcId

        unless func?
            throw Error.FUNCTION_UNDEFINED.complete('name', funcId)

        { type, returnType, argTypes: expectedParamTypes } = func

        unless type is TYPES.FUNCTION
            throw Error.CALL_NON_FUNCTION.complete('name', funcId)

        if paramList.length isnt expectedParamTypes.length
            throw Error.INVALID_PARAMETER_COUNT_CALL.complete('name', funcId, 'good', expectedParamTypes.length, 'wrong', paramList.length)

        instructions = []

        for param, i in paramList
            { type: actualType, instructions: paramInstructions, result: paramResult } = param.compile state 
            { instructions: castingInstructions, result: castingResult } = ensureType paramResult, actualType, expectedParamTypes[i], state
            state.releaseTemporaries castingResult
            instructions = instructions.concat([ paramInstructions..., castingInstructions..., new ParamPush castingResult ])
    
        # Need to copy the temporaries that are currently being used because otherwise
        # they could be written over by the function being called
        instructions.push new Funcall(funcId, state.temporaryAddressOffset)

        return { type: returnType, result: new ReturnReference(returnType), instructions }

    # Increase the temporary offset
    # Increase the function stack offset by the current functions stack size

@ParamPush = class ParamPush extends Ast
    # [ value ] = @children 