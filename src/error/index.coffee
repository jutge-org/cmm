assert = require 'assert'

module.exports = @

copy = (obj) -> JSON.parse JSON.stringify(obj)

@InterpretationError = class InterpretationError extends Error
    constructor: (@code, @message, @generated = yes) ->
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


e "PARSE_ERROR", 100, "Parsing error:\n<<error>>"
e "VARIABLE_REDEFINITION", 10, "Cannot define variable <<name>>: already defined in this scope"
e "GET_VARIABLE_NOT_DEFINED", 11, "Cannot get variable <<name>>: not defined in this scope"
e "SET_VARIABLE_NOT_DEFINED", 12, "Cannot set variable <<name>>: not defined in this scope"

e "FUNCTION_REDEFINITION", 13, "Cannot define function <<name>>: already defined"
e "VOID_FUNCTION_ARGUMENT", 14, "Cannot define a function argument with void type: function <<function>>, argument <<argument>>"
e "FUNCTION_UNDEFINED", 15, "Cannot call function <<name>>, variable is not declared"
e "CALL_NON_FUNCTION", 16, "Cannot call <<name>>, which is not a function"
e "INVALID_PARAMETER_COUNT_CALL", 17, "Function <<name>> with <<good>> parameters has been called with wrong number of parameters <<wrong>>"
e "IOSTREAM_LIBRARY_MISSING", 18, "<<name>> not found. iostream library needed."
e "ASSIGN_OF_NON_ASSIGNABLE", 19, "Variable <<variableName>> with type <<type>> is not assignable"

e "NO_RETURN_TYPE", 21, "Function <<function>> declared with no return type"

e "VOID_DECLARATION", 30, "Cannot declare a variable with type void: variable <<name>>"

e "INVALID_CAST", 20, "Cannot cast type <<origin>> to type <<dest>>"

e "NON_INTEGRAL_MODULO", 40, "Both operands to modulo operation must be integrals"

e "MAIN_NOT_DEFINED", 50, "You must define a main function"
e "INVALID_MAIN_TYPE", 51, "Main must return int"

e "CIN_OF_NON_ID", 60, "Cin must be used with variables"
e "CIN_OF_NON_ASSIGNABLE", 61, "Cin variables must be assignable"
e "CIN_VARIABLE_UNDEFINED", 62, "Cannot cin variable <<name>>: undeclared"
e "COUT_OF_INVALID_TYPE", 63, "Invalid cout parameter"

e "CONST_MODIFICATION", 71, "Modification of read-only variable <<name>>"

e "DUPLICATE_SPECIFIER", 72, "Duplicate declaration specifier <<specifier>>"

e "NO_TYPE_SPECIFIER", 73, "A type specifier is required for all declarations"

e "CONST_MODIFICATION", 71, "Modification of read-only variable <<name>>"

e "DUPLICATE_SPECIFIER", 72, "Duplicate declaration specifier <<specifier>>"
e "NO_TYPE_SPECIFIER", 73, "A type specifier is required for all declarations"

# Execution errors
e "GET_VARIABLE_NOT_ASSIGNED", 2, "Cannot get variable <<name>>: hasn't been assigned"
e "NO_RETURN", 3, "return-statement with no value, in function '<<name>>' returning '<<expected>>'"
e "DIVISION_BY_ZERO", 4, "You divided by zero"
e "MODULO_BY_ZERO", 5, "You tried to compute a modulo with zero"