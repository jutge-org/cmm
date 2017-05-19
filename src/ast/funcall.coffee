{ Ast } = require './ast'
{ PRIMITIVE_TYPES, ensureType, EXPR_TYPES } = require './type'
Error = require '../error'
{ MemoryReference, StackReference } = require './memory-reference'
{ Assign } = require './assign'

module.exports = @

@Funcall = class Funcall extends Ast
    compile: (state) ->
        [ { children: [ funcId ] }, paramList ] = @children

        # Comprovar que la variable cridada esta definida
        # Comprovar que el id que s'està cridant té realment tipus funció
        # Comprovar/castejar que tots els paràmetres de la crida tenen el tipus que toca
        # Retorna el tipus de la funció

        func = state.getFunction funcId

        unless func?
            throw Error.FUNCTION_UNDEFINED.complete('name', funcId)

        { type, returnType, argTypes: expectedParamTypes } = func

        unless type is PRIMITIVE_TYPES.FUNCTION
            throw Error.CALL_NON_FUNCTION.complete('name', funcId)

        if paramList.length isnt expectedParamTypes.length
            throw Error.INVALID_PARAMETER_COUNT_CALL.complete('name', funcId, 'good', expectedParamTypes.length, 'wrong', paramList.length)

        instructions = []

        paramPushResults = []
        for param, i in paramList
            { type: actualType, instructions: paramInstructions, result: paramResult } = param.compile state 
            { instructions: castingInstructions, result: castingResult } = ensureType paramResult, actualType, expectedParamTypes[i], state
            paramPushResults.push castingResult
            instructions = instructions.concat([ paramInstructions..., castingInstructions... ])

        offset = 0
        for paramPushResult in paramPushResults
            state.releaseTemporaries paramPushResult
            instructions.push new ParamPush paramPushResult, offset
            offset += paramPushResult.getType().bytes

    
        # Need to copy the temporaries that are currently being used because otherwise
        # they could be written over by the function being called
        instructions.push new Funcall(funcId, state.temporaryAddressOffset)

        result =
            if returnType isnt PRIMITIVE_TYPES.VOID
                tmp = state.getTemporary returnType
                returnReference = MemoryReference.from(returnType, null, MemoryReference.RETURN)
                instructions.push new Assign(tmp, returnReference)
                tmp
            else
                null

        instructions.forEach((x) => x.locations = @locations)

        return { type: returnType, result, instructions, exprType: EXPR_TYPES.RVALUE }

    # Increase the temporary offset
    # Increase the function stack offset by the current functions stack size
    execute: (vm) ->
        [ funcId, temporaryOffset ] = @children

        vm.controlStack.push { func: vm.func, instruction: vm.pointers.instruction, temporariesOffset: vm.pointers.temporaries }

        vm.pointers.temporaries += temporaryOffset
        vm.pointers.stack += vm.func.stackSize
        vm.pointers.instruction = -1 # It will be incremented after the funcall instruction is executed

        vm.func = vm.functions[funcId]
        vm.instructions = vm.func.instructions

    isFuncall: yes



@ParamPush = class ParamPush extends Ast
    execute: ({ memory, func }) ->
        [ value, offset ] = @children

        ref = new StackReference(value.getType(), func.stackSize + offset)
        ref.write(memory, value.read(memory))
