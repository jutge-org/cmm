assert = require 'assert'

module.exports = @

copy = (obj) -> JSON.parse JSON.stringify(obj)

@InterpretationError = class InterpretationError
    constructor: (@code, @message) ->
    complete: (placeHolder, text, others...) ->
        others.unshift(placeHolder, text)
        ret = copy @
        while others.length > 0
            [placeHolder, text, others...] = others
            placeHolder =  "<<#{placeHolder}>>"
            index = ret.message.indexOf placeHolder
            assert index >= 0
            ret.message = ret.message.replace placeHolder, text
        ret

e = (name, code, message) => @[name] = new InterpretationError code, message

# Example of use: error = require './error'; throw error.VARIABLE_ALREADY_DEFINED

# TODO: Improve error messages
# TODO: Organise errors in a better way

e "VARIABLE_REDEFINITION", 10, "Cannot define variable <<name>>: already defined in this scope"
e "GET_VARIABLE_NOT_DEFINED", 11, "Cannot get variable <<name>>: not defined in this scope"
e "SET_VARIABLE_NOT_DEFINED", 12, "Cannot set variable <<name>>: not defined in this scope"

e "FUNCTION_REDEFINITION", 13, "Cannot define function <<name>>: already defined"
e "VOID_FUNCTION_ARGUMENT", 14, "Cannot define a function argument with void type: function <<function>>, argument <<argument>>"
e "FUNCTION_UNDEFINED", 15, "Cannot call function <<name>>, variable is not declared"
e "CALL_NON_FUNCTION", 16, "Cannot call <<name>>, which is not a function"
e "INVALID_PARAMETER_COUNT_CALL", 17, "Function <<name>> with <<good>> parameters has been called with wrong number of parameters <<wrong>>"
e "IOSTREAM_LIBRARY_MISSING", 18, "<<name>> not found. iostream library needed."

e "VOID_DECLARATION", 30, "Cannot declare a variable with type void: variable <<name>>"

e "INVALID_CAST", 20, "Cannot cast type <<origin>> to type <<dest>>"

e "NON_INTEGRAL_MODULO", 40, "Both operands to modulo operation must be integrals"

e "MAIN_NOT_DEFINED", 50, "You must define a main function"
e "INVALID_MAIN_TYPE", 51, "Main must return int"

e "CIN_OF_NON_ID", 60, "cin must be used with variables"
e "CIN_OF_NON_ASSIGNABLE", 61, "cin variables must be assignable"
e "CIN_VARIABLE_UNDEFINED", 62, "cannot cin variable <<name>>: undeclared"
e "COUT_OF_INVALID_TYPE", 63, "invalid cout parameter"

# Execution errors
e "GET_VARIABLE_NOT_ASSIGNED", 0, "Cannot get variable <<name>>: hasn't been assigned"
e "NO_RETURN", 1, "Non-void function <<name>> hasn't returned any value"
e "DIVISION_BY_ZERO", 2, "You divided by zero"
e "MODULO_BY_ZERO", 3, "You tried to compute a modulo with zero"
