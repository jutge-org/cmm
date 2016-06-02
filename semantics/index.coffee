assert = require 'assert'

Ast = require '../parser/ast'
Error = require '../error'
valueParser = require '../parser/value-parser'

{ NODES, TYPES, OPERATORS, CASTS, LITERALS, STATEMENTS } = Ast

# TODO: This casting information should go somewhere else
CASTINGS = {}
INCLUDES = []

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

CASTINGS[TYPES.CIN][TYPES.BOOL] = CASTS.CIN2BOOL

# TODO: This size info should go somewhere else
SIZE_OF_TYPE = {}
SIZE_OF_TYPE[TYPES.BOOL] = 1
SIZE_OF_TYPE[TYPES.CHAR] = 8
SIZE_OF_TYPE[TYPES.INT] = 32
SIZE_OF_TYPE[TYPES.DOUBLE] = 64

# TODO: This type classifications should go somewhere else
isIntegral = (type) -> type in [TYPES.INT, TYPES.BOOL, TYPES.CHAR]
isAssignable = (type) -> type not in [TYPES.FUNCTION, TYPES.VOID]

module.exports = @

functions = {}

copy = (obj) -> JSON.parse JSON.stringify(obj)

checkVariableDefined = (id, definedVariables) ->
    unless definedVariables[id]?
        throw Error.GET_VARIABLE_NOT_DEFINED.complete('name', id)

tryToCast = (ast, originType, destType) ->
    assert originType?
    assert destType?

    if CASTINGS[originType][destType]?
        ast.addParent(CASTINGS[originType][destType])
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
                if declarationAst.getType() is NODES.ID # No need to check, only an id
                    id = declarationAst.getChild(0)
                else # Is assign
                    id = declarationAst.getChild(0).getChild(0)
                    valueAst = declarationAst.getChild(1)
                    actualType = checkAndPreprocess valueAst, definedVariables, functionId

                    if type isnt actualType
                        tryToCast(valueAst, actualType, type)

                if definedVariables[id]?
                    throw Error.VARIABLE_REDEFINITION.complete('name', id)
                else
                    definedVariables[id] = type

            return TYPES.VOID
        when NODES.BLOCK_INSTRUCTIONS
            for child in ast.getChildren() when child instanceof Ast
                checkAndPreprocess child, definedVariables, functionId

            return TYPES.VOID
        when NODES.FUNCALL
            # Comprovar que la variable cridada esta definida
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
        when OPERATORS.ASSIGN
            # Comprovar/castejar que el tipus del id que s'assigna es el mateix que el del literal/part dreta
            # Comprovar que el tipus al que s'assigna no es void
            # Retorna el tipus de la expressió de la dreta
            variableId = ast.getChild(0).getChild(0)
            variableType = checkAndPreprocess ast.getChild(0), definedVariables, functionId

            if variableType is TYPES.VOID
                throw Error.VOID_DECLARATION.complete('name', variableId)

            valueAst = ast.getChild(1)

            valueType = checkAndPreprocess valueAst, definedVariables, functionId

            if valueType isnt variableType
                tryToCast valueAst, valueType, variableType

            return valueType
        when LITERALS.DOUBLE, LITERALS.INT, LITERALS.STRING, LITERALS.CHAR, LITERALS.BOOL
            valueParser.parseLiteral ast
        when OPERATORS.PLUS, OPERATORS.MINUS, OPERATORS.MUL
            # Comprovar/castejar que els dos tipus siguin iguals, i que siguin
            # o bé integrals (char castejat a int o int o bool cast a int)
            # o bé reals (double). Es casteja de menys tamany a mes sempre, mai al reves

            # Retorna tipus el dels dos operands igualats
            leftAst = ast.getChild(0)
            rightAst = ast.getChild(1)
            typeLeft = checkAndPreprocess leftAst, definedVariables, functionId
            typeRight = checkAndPreprocess rightAst, definedVariables, functionId

            castingType = if TYPES.DOUBLE in [typeLeft, typeRight] then TYPES.DOUBLE else TYPES.INT
            if typeLeft isnt castingType
                tryToCast(leftAst, typeLeft, castingType)
            if typeRight isnt castingType
                tryToCast(rightAst, typeRight, castingType)

            return castingType
        when OPERATORS.UPLUS, OPERATORS.UMINUS
            # Comprovar/castejar que el tipus sigui
            # o bé integral (char castejat a int o int o bool cast a int)
            # o bé real (double).

            # Retorna tipus el del operand

            type = checkAndPreprocess(ast.getChild(0), definedVariables, functionId)

            if type isnt TYPES.DOUBLE and type isnt TYPES.INT
                tryToCast ast.getChild(0), type, TYPES.INT
                return TYPES.INT
            return type
        when OPERATORS.DIV
            # Comprovar/castejar que els dos tipus siguin iguals, i que siguin
            # o bé integrals (char castejat a int o int o bool cast a int)
            # o bé reals (double). Es casteja de menys tamany a mes sempre, mai al reves

            # Es genera una instruccio (sa de canviar el type) DOUBLE_DIV si els operands son doubles
            # o INT_DIV si els operands son ints

            # Retorna tipus el dels dos operands igualats (int o double)

            leftAst = ast.getChild(0)
            rightAst = ast.getChild(1)
            typeLeft = checkAndPreprocess leftAst, definedVariables, functionId
            typeRight = checkAndPreprocess rightAst, definedVariables, functionId

            castingType = if TYPES.DOUBLE in [typeLeft, typeRight] then TYPES.DOUBLE else TYPES.INT

            if typeLeft isnt castingType
                tryToCast(leftAst, typeLeft, castingType)
            if typeRight isnt castingType
                tryToCast(rightAst, typeRight, castingType)

            if castingType is TYPES.DOUBLE
                ast.setType OPERATORS.DOUBLE_DIV
            else
                ast.setType OPERATORS.INT_DIV

            return castingType
        when OPERATORS.MOD
            # Comprovar/castejar que els dos tipus siguin iguals, i que siguin
            # integrals (char castejat a int o int o bool cast a int)

            # Retorna tipus int
            leftAst = ast.getChild(0)
            rightAst = ast.getChild(1)
            typeLeft = checkAndPreprocess leftAst, definedVariables, functionId
            typeRight = checkAndPreprocess rightAst, definedVariables, functionId

            unless isIntegral typeLeft
                throw Error.NON_INTEGRAL_MODULO
            unless isIntegral typeRight
                throw Error.NON_INTEGRAL_MODULO

            if typeLeft isnt TYPES.INT
                tryToCast(leftAst, typeLeft, TYPES.INT)
            if typeRight isnt TYPES.INT
                tryToCast(rightAst, typeRight, TYPES.INT)

            return TYPES.INT
        when OPERATORS.LT, OPERATORS.GT, OPERATORS.LTE, OPERATORS.GTE, OPERATORS.EQ, OPERATORS.NEQ
            # Comprovar/castejar que els dos tipus siguin iguals, i que siguin
            # o bé integrals (char castejat a int o int o bool cast a int)
            # o bé reals (double). Es casteja de menys tamany a mes sempre, mai al reves
            # o bé bools

            # Retorna tipus bool
            leftAst = ast.getChild(0)
            rightAst = ast.getChild(1)
            typeLeft = checkAndPreprocess leftAst, definedVariables, functionId
            typeRight = checkAndPreprocess rightAst, definedVariables, functionId

            if typeLeft isnt typeRight
                if SIZE_OF_TYPE[typeLeft] > SIZE_OF_TYPE[typeRight]
                    tryToCast(rightAst, typeRight, typeLeft)
                else
                    tryToCast(leftAst, typeLeft, typeRight)

            return TYPES.BOOL
        when OPERATORS.AND, OPERATORS.OR
            # Comprovat/castejar que els dos tipus siguin iguals, i que siguin bools
            leftAst = ast.getChild(0)
            rightAst = ast.getChild(1)
            typeLeft = checkAndPreprocess leftAst, definedVariables, functionId
            typeRight = checkAndPreprocess rightAst, definedVariables, functionId

            if typeLeft isnt TYPES.BOOL
                tryToCast leftAst, typeLeft, TYPES.BOOL
            if typeRight isnt TYPES.BOOL
                tryToCast rightAst, typeRight, TYPES.BOOL

            return TYPES.BOOL
            # Retorna tipus bool
        when OPERATORS.NOT
            # Comprovat/castejar que el tipus sigui igual, i que sigui bool
            # Retorna tipus bool

            valueAst = ast.child()
            type = checkAndPreprocess valueAst, definedVariables, functionId

            if type isnt TYPES.BOOL
                tryToCast valueAst, type, TYPES.BOOL

            return TYPES.BOOL
        when OPERATORS.POST_INC
            # Comprovar/castejar que el tipus sigui
            # o bé integral (char castejat a int o int o bool cast a int)
            # o bé real (double).

            # Retorna tipus el del operand

            type = checkAndPreprocess(ast.child(), definedVariables, functionId)
            if type isnt TYPES.DOUBLE and type isnt TYPES.INT
                tryToCast ast.child(), type, TYPES.INT
                return TYPES.INT
            return type

        when OPERATORS.POST_DEC
            # Comprovar/castejar que el tipus sigui
            # o bé integral (char castejat a int o int o bool cast a int)
            # o bé real (double).

            # Retorna tipus el del operand

            type = checkAndPreprocess(ast.child(), definedVariables, functionId)
            if type isnt TYPES.DOUBLE and type isnt TYPES.INT
                tryToCast ast.child(), type, TYPES.INT
                return TYPES.INT
            return type
        when STATEMENTS.IF_THEN
            # Comprovar/castejar que la condicio es un boolea
            # Comprovar recursivament el cos del then

            # Retorna void
            conditionAst = ast.getChild(0)
            conditionType = checkAndPreprocess conditionAst, definedVariables, functionId

            if conditionType isnt TYPES.BOOL
                tryToCast conditionAst, conditionType, TYPES.BOOL

            thenBodyAst = ast.getChild(1)
            definedVariablesAux = copy definedVariables
            checkAndPreprocess thenBodyAst, definedVariablesAux, functionId

            return TYPES.VOID
        when STATEMENTS.IF_THEN_ELSE
            # Comprovar/castejar que la condicio es un boolea
            # Comprovar recursivament el cos del then i del else

            # Retorna void
            conditionAst = ast.getChild(0)
            conditionType = checkAndPreprocess conditionAst, definedVariables, functionId

            if conditionType isnt TYPES.BOOL
                tryToCast conditionAst, conditionType, TYPES.BOOL

            thenBodyAst = ast.getChild(1)
            definedVariablesAux = copy definedVariables
            checkAndPreprocess thenBodyAst, definedVariablesAux, functionId
            definedVariablesAux = copy definedVariables
            elseBodyAst = ast.getChild(2)
            checkAndPreprocess elseBodyAst, definedVariablesAux, functionId

            return TYPES.VOID
        when STATEMENTS.WHILE
            # Comprovar/castejar que la condicio es un boolea
            # Comprovar recursivament el cos del while

            # Retorna void
            conditionAst = ast.getChild(0)
            conditionType = checkAndPreprocess conditionAst, definedVariables, functionId

            if conditionType isnt TYPES.BOOL
                tryToCast conditionAst, conditionType, TYPES.BOOL

            bodyAst = ast.getChild(1)
            definedVariablesAux = copy definedVariables
            checkAndPreprocess bodyAst, definedVariablesAux, functionId

            return TYPES.VOID
        when STATEMENTS.FOR
            # Comprovar recursivament la inicialitzacio i el increment, comprovar/castejar que la condicio es un boolea
            # Comprovar recursivament el cos del for
            # Retorna void
            definedVariablesAux = copy definedVariables
            initAst = ast.getChild(0)
            conditionAst = ast.getChild(1)
            incrementAst = ast.getChild(2)
            bodyAst = ast.getChild(3)
            checkAndPreprocess initAst, definedVariablesAux, functionId
            conditionType = checkAndPreprocess conditionAst, definedVariablesAux, functionId

            if conditionType isnt TYPES.BOOL
                tryToCast conditionAst, conditionType, TYPES.BOOL

            checkAndPreprocess incrementAst, definedVariablesAux, functionId
            checkAndPreprocess bodyAst, definedVariablesAux, functionId

            return TYPES.VOID
        when STATEMENTS.RETURN # Com collons sabré el tipus de la funció? :S (l'hauré de passar com a paràmetre d'aquesta...)
            # Comprovar/castejar que retorna el mateix tipus que el de la funció en la que estem
            # Si la funció en la que estem retorna void sa danar al tanto

            # Retorna void
            if ast.getChildCount() > 0 # return x
                valueAst = ast.getChild(0)
                actualType = checkAndPreprocess valueAst, definedVariables, functionId
            else
                actualType = TYPES.VOID

            expectedType = functions[functionId].returnType
            if actualType isnt expectedType
                tryToCast valueAst, actualType, expectedType

            return TYPES.VOID
        when STATEMENTS.CIN
            if 'iostream' not in INCLUDES
                throw Error.IOSTREAM_LIBRARY_MISSING.complete('name', STATEMENTS.CIN)
            # Comprovar que tots els fills son ids i que tenen tipus assignable
            # retorna bool
            for child in ast.getChildren()
                if child.getType() isnt NODES.ID
                    throw Error.CIN_OF_NON_ID
                else
                    varId = child.getChild(0)
                    unless definedVariables[varId]?
                        throw Error.CIN_VARIABLE_UNDEFINED.complete('name', varId)
                    else unless isAssignable definedVariables[varId]
                        throw Error.CIN_OF_NON_ASSIGNABLE
                    else
                        child.addParent definedVariables[varId]
            return TYPES.CIN
        when STATEMENTS.COUT
            if 'iostream' not in INCLUDES
                throw Error.IOSTREAM_LIBRARY_MISSING.complete('name', STATEMENTS.COUT)
            # Comprovar/castejar que tots els fills siguin strings o endl, que es convertira a "\n" (string)
            # Retorna void
            for child in ast.getChildren()
                if child.getType() is NODES.ENDL
                    child.setType(LITERALS.STRING)
                    child.setChild(0, "\n")
                else
                    type = checkAndPreprocess child, definedVariables, functionId

                    if type isnt TYPES.STRING
                        child.addParent(
                            switch type
                                when TYPES.INT then CASTS.INT2COUT
                                when TYPES.BOOL then CASTS.BOOL2COUT
                                when TYPES.CHAR then CASTS.CHAR2COUT
                                when TYPES.DOUBLE then CASTS.DOUBLE2COUT
                                else
                                    throw Error.COUT_OF_INVALID_TYPE
                        )


            return TYPES.VOID
        else # I don't care about its type, but I need to recurse cause it could have children whose types is one of the above
            for child in ast.getChildren() when child instanceof Ast
                checkAndPreprocess(child, definedVariables, functionId)

            return TYPES.VOID


@checkSemantics = (root) ->
    assert root?

    INCLUDES = []
    includes = root.getChild(0)

    for incl in includes.getChildren()
        if incl.getType() is 'INCLUDE'
            id = incl.getChild(0).getChild(0)
            INCLUDES.push(id)


    ast = root.getChild(1)
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

    if definedVariables.main isnt TYPES.FUNCTION
        throw Error.MAIN_NOT_DEFINED
    else if functions.main.returnType isnt TYPES.INT
        throw Error.INVALID_MAIN_TYPE

    ast
