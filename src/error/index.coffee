assert = require 'assert'

module.exports = @

copy = (obj) -> JSON.parse JSON.stringify(obj)

class CmmError extends Error
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

e = (name, code, message) => @[name] = new CmmError code, message

# Example of use: error = require './error'; throw error.VARIABLE_ALREADY_DEFINED

# TODO: Improve error messages
# TODO: Organise errors in a better way


e "PARSE_ERROR", 100, "Parsing error:\n<<error>>"
e "VARIABLE_REDEFINITION", 10, "Cannot define variable '<<name>>': already defined in this scope"
e "GET_VARIABLE_NOT_DEFINED", 11, "Cannot get variable '<<name>>': not defined in this scope"
e "SET_VARIABLE_NOT_DEFINED", 12, "Cannot set variable '<<name>>': not defined in this scope"
e "REF_VARIABLE_NOT_DEFINED", 13, "Cannot reference variable '<<name>>': not defined in this scope"

e "FUNCTION_REDEFINITION", 13, "Cannot define function '<<name>>': already defined"
e "VOID_FUNCTION_ARGUMENT", 14, "Cannot define a function argument with void type: function '<<function>>', argument '<<argument>>'" # TODO: Not used right now falls to declaration one, should be used again
e "FUNCTION_UNDEFINED", 15, "Cannot call function '<<name>>', variable is not declared"
e "CALL_NON_FUNCTION", 16, "Cannot call '<<name>>', which is not a function"
e "INVALID_PARAMETER_COUNT_CALL", 17, "Function '<<name>>' with '<<good>>' parameters has been called with wrong number of parameters '<<wrong>>'"
e "IOSTREAM_LIBRARY_MISSING", 18, "'<<name>>' not found. iostream library needed."
e "ASSIGN_OF_NON_ASSIGNABLE", 19, "Variable '<<variableName>>' with type '<<type>>' is not assignable"
e "LVALUE_ASSIGN", 190, "lvalue required as left operand of assignment"
e "ASSIGN_TO_ARRAY", 191, "invalid array assignment"
e "INVALID_ARRAY_SUBSCRIPT", 192, "invalid types '<<type>>[<<typeSubscript>>]' for array subscript"
e "LVALUE_CIN", 193, "lvalue required as operand of cin"

e "NO_RETURN_TYPE", 21, "Function '<<function>>' declared with no return type"

e "VOID_DECLARATION", 30, "Variable or field '<<name>>' declared void"
e "VOID_ARRAY_DECLARATION", 31, "Declaration of '<<name>>' as array of void"

e "INVALID_CAST", 20, "Cannot cast type '<<origin>>' to type '<<dest>>'"

e "NON_INTEGRAL_MODULO", 40, "Both operands to modulo operation must be integrals"

e "INVALID_BOOL_DEC", 41, "Invalid use of boolean expression as operand to 'operator--'"


e "MAIN_NOT_DEFINED", 50, "You must define a main function"
e "INVALID_MAIN_TYPE", 51, "Main must return int"

e "CIN_OF_NON_ID", 60, "Cin must be used with variables"
e "CIN_OF_NON_ASSIGNABLE", 61, "Cin variables must be assignable"
e "CIN_VARIABLE_UNDEFINED", 62, "Cannot cin variable '<<name>>': undeclared"
e "CANNOT_COUT_TYPE", 63, "Cannot cout value with type '<<type>>'"

e "CONST_MODIFICATION", 71, "Modification of read-only variable '<<name>>'"

e "DUPLICATE_SPECIFIER", 72, "Duplicate declaration specifier '<<specifier>>'"

e "NO_TYPE_SPECIFIER", 73, "A type specifier is required for all declarations"

e "CONST_MODIFICATION", 71, "Modification of read-only variable '<<name>>'"

e "DUPLICATE_SPECIFIER", 72, "Duplicate declaration specifier <<specifier>>"
e "NO_TYPE_SPECIFIER", 73, "A type specifier is required for all declarations"

e "ALL_BOUNDS_EXCEPT_FIRST", 80, "Multidimensional array '<<id>>' must have bounds for all dimensions except the first"
e "STORAGE_UNKNOWN", 81, "Storage size of '<<id>>' isn't known"

# Execution errors
e "DIVISION_BY_ZERO", 136, "Floating point exception: division by zero"
e "MODULO_BY_ZERO", 137, "Floating point exception: modulo by zero"