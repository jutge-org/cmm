assert = require 'assert'

Ast = require '../parser/ast'
Error = require '../error'

{ NODES, TYPES, OPERATORS, CASTS } = Ast

CASTINGS = {}

for TYPE of TYPES
    CASTINGS[TYPE] = {}

CASTINGS[TYPES.INT][TYPES.DOUBLE] = CASTS.INT2DOUBLE
CASTINGS[TYPES.INT][TYPES.CHAR] = CASTS.INT2CHAR
CASTINGS[TYPES.INT][TYPES.BOOL] = CASTS.INT2BOOL

CASTINGS[TYPES.DOUBLE][TYPES.INT] = CASTS.DOUBLE2INT
CASTINGS[TYPES.DOUBLE][TYPES.CHAR] = CASTS.DOUBLE2CHAR
CASTINGS[TYPES.DOUBLE][TYPES.BOOL] = CASTS.DOUBLE2BOOL

CASTINGS[TYPES.CHAR][TYPES.INT] = CASTS.CHAR2INT
CASTINGS[TYPES.CHAR][TYPES.DOUBLE] = CASTS.CHAR2DOUBLE
CASTINGS[TYPES.CHAR][TYPES.BOOL] = CASTS.CHAR2BOOL

CASTINGS[TYPES.BOOL][TYPES.INT] = CASTS.BOOL2INT
CASTINGS[TYPES.BOOL][TYPES.DOUBLE] = CASTS.BOOL2DOUBLE
CASTINGS[TYPES.BOOL][TYPES.CHAR] = CASTS.BOOL2CHAR

module.exports = @

functions = {}

copy = (obj) -> JSON.parse JSON.stringify(obj)

checkVariableDefined = (id, definedVariables) ->
    unless definedVariables[id]?
        throw Error.GET_VARIABLE_NOT_DEFINED.complete('name', id)


checkDeclaration = (declarationAst, type, definedVariables) ->
    id =
        if declarationAst.getType() is NODES.ID
            declarationAst.getChild(0)
        else
            declarationAst.getChild(0).getChild(0)
    if definedVariables[id]?
        throw Error.VARIABLE_REDEFINITION.complete('name', id)
    else
        definedVariables[id] = type

tryToCast = (ast, originType, destType) ->
    if CASTINGS[originType][destType]?
        ast.cast(CASTINGS[originType][destType])
    else
        throw Error.INVALID_CAST.complete('origin', originType, 'dest', destType)

checkAndPreprocess = (ast, definedVariables, functionId) ->
    switch ast.getType()
        when NODES.ID
            id = ast.getChild(0)
            checkVariableDefined(id, definedVariables)
            return definedVariables[id]
        when NODES.DECLARATION
            declarations = ast.getChild(1)
            type = ast.getChild(0)

            for declarationAst in declarations
                checkDeclaration(declarationAst, type, definedVariables)
                checkAndPreprocess declarationAst, definedVariables, functionId

            return TYPES.VOID
        when NODES.BLOCK_INSTRUCTIONS
            definedVariablesAux = copy definedVariables
            for child in ast.getChildren() when child instanceof Ast
                checkAndPreprocess child, definedVariablesAux, functionId

            return TYPES.VOID
        when NODES.FUNCALL
            # Comprovar que el id que s'està cridant té realment tipus funció
            # Comprovar/castejar que tots els paràmetres de la crida tenen el tipus que toca
            # Retorna el tipus de la funció

            funcId = ast.getChild(0).getChild(0)
            if definedVariables[funcId]?
                if definedVariables[funcId] is TYPES.FUNCTION
                    assert functions[funcId]?
                    paramList = ast.getChild(1)
                    assert paramList.getType() is NODES.PARAM_LIST

                    expectedLength = functions[funcId].argTypes.length
                    actualLength = paramList.getChildCount()
                    if actualLength isnt expectedLength
                        throw Error.INVALID_PARAMETER_COUNT_CALL.complete('name', funcId, 'good', expectedLength, 'wrong', actualLength)
                    for argType, i in functions[funcId].argTypes
                        type = checkAndPreprocess(paramList.getChild(i), definedVariables, functionId)
                        if type isnt argType
                            tryToCast(paramList.getChild(i), type, argType)
                    return functions[funcId].returnType
                else
                    throw Error.CALL_NON_FUNCTION.complete('name', funcId)
            else
                throw Error.FUNCTION_UNDEFINED.complete('name', funcId)
        when NODES.ASSIGN
            # Comprovar/castejar que el tipus del id que s'assigna es el mateix que el del literal/part dreta
            # Comprovar que el tipus al que s'assigna no es void
            # Retorna void
            variableId = ast.getChild(0).getChild(0)
            variableType = definedVariables[variableId]

            if variableType is TYPES.VOID
                throw Error.VOID_DECLARATION.complete('name', variableId)

            valueAst = ast.getChild(1)

            valueType = checkAndPreprocess valueAst, definedVariables, functionId

            if valueType isnt variableType
                tryToCast valueAst, valueType, variableType

            return TYPES.VOID
        else # I don't care about its type, but I need to recurse cause it could have children whose types is one of the above
            for child in ast.getChildren() when child instanceof Ast
                checkAndPreprocess(child, definedVariables, functionId)

            return TYPES.VOID
    ###
    when LITERALS.DOUBLE
        return TYPES.DOUBLE
    when LITERALS.INT
        return TYPES.INT
    when LITERALS.STRING
        return TYPES.STRING
    when LITERALS.CHAR
        return TYPES.CHAR
    when LITERALS.BOOL
        return TYPES.BOOL
    when OPERATORS.PLUS, OPERATORS.MINUS, OPERATORS.MUL
        # Comprovar/castejar que els dos tipus siguin iguals, i que siguin
        # o bé integrals (char castejat a int o int o bool cast a int)
        # o bé reals (double). Es casteja de menys tamany a mes sempre, mai al reves

        # Retorna tipus el dels dos operands igualats
    when OPERATORS.UPLUS
        # COmprovar/castejar que el tipus sigui
        # o bé integral (char castejat a int o int o bool cast a int)
        # o bé real (double).

        # Retorna tipus el del operand
    when OPERATORS.UMINUS
        # COmprovar/castejar que el tipus sigui
        # o bé integral (char castejat a int o int o bool cast a int)
        # o bé real (double).
    when OPERATORS.DIV
        # Comprovar/castejar que els dos tipus siguin iguals, i que siguin
        # o bé integrals (char castejat a int o int o bool cast a int)
        # o bé reals (double). Es casteja de menys tamany a mes sempre, mai al reves

        # Es genera una instruccio (sa de canviar el type) DIVREAL si els operands son doubles
        # o DIVINTEGRAL si els operands son ints

        # Retorna tipus el dels dos operands igualats (int o double)
    when OPERATORS.MOD
        # Comprovar/castejar que els dos tipus siguin iguals, i que siguin
        # integrals (char castejat a int o int o bool cast a int)

        # Retorna tipus int
    when OPERATORS.LT
        # Comprovar/castejar que els dos tipus siguin iguals, i que siguin
        # o bé integrals (char castejat a int o int o bool cast a int)
        # o bé reals (double). Es casteja de menys tamany a mes sempre, mai al reves

        # Retorna tipus bool
    when OPERATORS.GT
        # Comprovar/castejar que els dos tipus siguin iguals, i que siguin
        # o bé integrals (char castejat a int o int o bool cast a int)
        # o bé reals (double). Es casteja de menys tamany a mes sempre, mai al reves

        # Retorna tipus bool
    when OPERATORS.LTE
        # Comprovar/castejar que els dos tipus siguin iguals, i que siguin
        # o bé integrals (char castejat a int o int o bool cast a int)
        # o bé reals (double). Es casteja de menys tamany a mes sempre, mai al reves

        # Retorna tipus bool
    when OPERATORS.GTE
        # Comprovar/castejar que els dos tipus siguin iguals, i que siguin
        # o bé integrals (char castejat a int o int o bool cast a int)
        # o bé reals (double). Es casteja de menys tamany a mes sempre, mai al reves

        # Retorna tipus bool
    when OPERATORS.EQ
        # Comprovar/castejar que els dos tipus siguin iguals, i que siguin
        # o bé integrals (char castejat a int o int o bool cast a int)
        # o bé reals (double). Es casteja de menys tamany a mes sempre, mai al reves

        # Retorna tipus bool
    when OPERATORS.NEQ
        # Comprovar/castejar que els dos tipus siguin iguals, i que siguin
        # o bé integrals (char castejat a int o int o bool cast a int)
        # o bé reals (double). Es casteja de menys tamany a mes sempre, mai al reves

        # Retorna tipus bool
    when STATEMENTS.IF_THEN
        # Comprovar/castejar que la condicio es un boolea
        # Comprovar recursivament el cos del then

        # Retorna void
    when STATEMENTS.IF_THEN_ELSE
        # Comprovar/castejar que la condicio es un boolea
        # Comprovar recursivament el cos del then i del else

        # Retorna void
    when STATEMENTS.WHILE
        # Comprovar/castejar que la condicio es un boolea
        # Comprovar recursivament el cos del while

        # Retorna void
    when STATEMENTS.FOR
        # Comprovar recursivament la inicialitzacio i el increment, comprovar/castejar que la condicio es un boolea
        # Comprovar recursivament el cos del for

        # Retorna void
    when STATEMENTS.RETURN # Com collons sabré el tipus de la funció? :S (l'hauré de passar com a paràmetre d'aquesta...)
        # Comprovar/castejar que retorna el mateix tipus que el de la funció en la que estem
        # Si la funció en la que estem retorna void sa danar al tanto

        # Retorna void
    when STATEMENTS.CIN
        # Comprovar que tots els fills son ids
        # retorna bool
    when STATEMENTS.COUT
        # Comprovar/castejar que tots els fills siguin strings o endl, que es convertira a "\n" (string)
        # Retorna void
    ###
    ###
    ###


@checkVariables = (ast) ->
    assert ast.getType() is NODES.BLOCK_FUNCTIONS
    definedVariables = {}

    for functionAst in ast.getChildren()
        # Define all the variables of type function
        # HACK: Assumes all childrens of the root are functions
        assert functionAst.getType() is TYPES.FUNCTION

        returnType = functionAst.getChild(0)
        functionId = functionAst.getChild(1).getChild(0)

        if definedVariables[functionId]?
            throw Error.FUNCTION_REDEFINITION.complete('name', functionId)

        definedVariables[functionId] = TYPES.FUNCTION

        functions[functionId] = { returnType,  argTypes: [] }

        # For each function, define its parameters and check its body recursively
        argListAst = functionAst.getChild(2)
        assert argListAst.getType() is NODES.ARG_LIST

        definedVariablesAux = copy definedVariables

        for argAst in argListAst.getChildren()
            assert argAst.getType() is NODES.ARG
            argId = argAst.getChild(1).getChild(0)
            argType = argAst.getChild(0)

            if argType is TYPES.VOID
                throw Error.VOID_FUNCTION_ARGUMENT.complete('function', functionId, 'argument', argId)

            functions[functionId].argTypes.push argType

            if definedVariablesAux[argId]?
                throw Error.VARIABLE_REDEFINITION.complete('name', argId)

            definedVariablesAux[argId] = argType

        blockInstructionsAst = functionAst.getChild(3)
        assert blockInstructionsAst.getType() is NODES.BLOCK_INSTRUCTIONS
        checkAndPreprocess(blockInstructionsAst, definedVariablesAux, functionId)


    ast
