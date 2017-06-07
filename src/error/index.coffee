assert = require 'assert'

module.exports = @

copy = (obj) -> JSON.parse JSON.stringify(obj)

class CmmError extends Error
    constructor: (@code, @message, @name, @generated = yes) ->
    complete: (placeHolder, text, others...) ->
        others.unshift(placeHolder, text)
        ret = new CmmError @code, @message, @name, @generated

        while others.length > 0
            [placeHolder, text, others...] = others
            bracedPlaceHolder = "<<<#{placeHolder}>>>"

            index = ret.message.indexOf bracedPlaceHolder
            isLiteral = index >= 0

            unless isLiteral
                bracedPlaceHolder =  "<<#{placeHolder}>>"
                index = ret.message.indexOf bracedPlaceHolder
                text = if text? then " '#{text}'" else " "

            assert index >= 0
            assert text?

            ret.message = ret.message.replace bracedPlaceHolder, text

        ret

c = (name, code, message) => @[name] = new CmmError code, message, "Compilation error"
e = (name, code, message) => @[name] = new CmmError code, message + "\n", "Execution error"

# Example of use: error = require './error'; throw error.VARIABLE_ALREADY_DEFINED

# TODO: Improve error messages
# TODO: Organise errors in a better way


c "PARSE_ERROR", 100, "Parsing error:\n<<error>>"
c "VARIABLE_REDEFINITION", 10, "Cannot define variable<<name>>: already defined in this scope"
c "GET_VARIABLE_NOT_DEFINED", 11, "Cannot get variable<<name>>: not defined in this scope"
c "SET_VARIABLE_NOT_DEFINED", 12, "Cannot set variable<<name>>: not defined in this scope"
c "REF_VARIABLE_NOT_DEFINED", 13, "Cannot reference variable<<name>>: not defined in this scope"

c "FUNCTION_REDEFINITION", 13, "Cannot define function<<name>>: already defined"
c "VOID_FUNCTION_ARGUMENT", 14, "Cannot define a function argument with void type: function<<function>>, argument<<argument>>" # TODO: Not used right now falls to declaration one, should be used again
c "FUNCTION_UNDEFINED", 15, "Cannot call function<<name>>, variable is not declared"
c "CALL_NON_FUNCTION", 16, "Cannot call<<name>>, which is not a function"
c "INVALID_PARAMETER_COUNT_CALL", 17, "Function<<name>> with<<good>> parameters has been called with wrong number of parameters<<wrong>>"
c "IOSTREAM_LIBRARY_MISSING", 18, "<<name>> not found. iostream library needed."
c "ASSIGN_OF_NON_ASSIGNABLE", 19, "Variable<<variableName>> with type<<type>> is not assignable"
c "LVALUE_ASSIGN", 190, "lvalue required as left operand of assignment"
c "ASSIGN_TO_ARRAY", 191, "invalid array assignment"
c "INVALID_ARRAY_SUBSCRIPT", 192, "invalid types '<<<type>>>[<<<typeSubscript>>>]' for array subscript"
c "LVALUE_CIN", 193, "lvalue required as operand of cin"
c "ARRAY_OF_FUNCTION", 194, "Declaration of<<id>> as array of functions" # Functions cannot return arrayts


c "INVALID_OPERANDS", 194, "Invalid operands<<typel>> and<<typer>> to operation"

c "WRONG_ARGUMENT_UNARY_MINUS", 195, "Wrong type argument to unary minus"

c "NO_RETURN_TYPE", 21, "Function<<function>> declared with no return type"

c "VOID_DECLARATION", 30, "Variable or field<<name>> declared void"
c "ARRAY_DECLARATION", 31, "Cannot declare<<name>> as array of<<type>>"
c "VOID_NOT_IGNORED", 32, "Void value not ignored as it ought to be"
c "REFERENCE_TO", 34, "Cannot declare<<id>> as reference to<<type>>"
c "POINTER_TO", 35, "Cannot declare<<id>> as pointer to<<type>>"

c "INVALID_CAST", 20, "Cannot cast type<<origin>> to type<<dest>>"

c "NON_INTEGRAL_MODULO", 40, "Both operands to modulo operation must be integrals"

c "INVALID_BOOL_DEC", 41, "Invalid use of boolean expression as operand to 'operator--'"


c "MAIN_NOT_DEFINED", 50, "You must define a main function"
c "INVALID_MAIN_TYPE", 51, "Main must return int"

c "CIN_OF_NON_ID", 60, "Cin must be used with variables"
c "CIN_OF_NON_ASSIGNABLE", 61, "Cin variables must be assignable"
c "CIN_VARIABLE_UNDEFINED", 62, "Cannot cin variable<<name>>: undeclared"
c "CANNOT_COUT_TYPE", 63, "Cannot cout value with type<<type>>"

c "CONST_MODIFICATION", 71, "Modification of read-only variable<<name>>"

c "DUPLICATE_SPECIFIER", 72, "Duplicate declaration specifier<<specifier>>"

c "NO_TYPE_SPECIFIER", 73, "A type specifier is required for all declarations"

c "CONST_MODIFICATION", 71, "Modification of read-only variable<<name>>"

c "DUPLICATE_SPECIFIER", 72, "Duplicate declaration specifier<<specifier>>"
c "NO_TYPE_SPECIFIER", 73, "A type specifier is required for all declarations"

c "ALL_BOUNDS_EXCEPT_FIRST", 80, "Multidimensional array<<id>> must have bounds for all dimensions except the first"
c "STORAGE_UNKNOWN", 81, "Storage size of<<id>> isn't known"
c "POINTER_UNBOUND_SIZE", 82, "Parameter<<id>> includes pointer to array of unknown bound<<type>>"
c "ARRAY_SIZE_NEGATIVE", 83, "Size of array<<id>> is negative"
c "LVALUE_ADDRESSING", 84, "Lvalue required as unary '&' operand"
c "ASSIGNABLE_ADDRESSING", 85, "Assignable type required as unary '&' operand"
c "INVALID_DEREFERENCE_TYPE", 86, "invalid type argument of unary '*' (have<<type>>)"

c "STATIC_SIZE_ARRAY", 87, "Invalid array dimension value for array<<id>>, only literals are supported as array dimensions" # TODO: Support const variables and static values
c "NONINTEGRAL_DIMENSION", 88, "Size of array<<id>> has non-integral type<<type>>"

c "UNALLOWED_ARITHMETIC_INCOMPLETE_TYPE", 93, "Cannot perform pointer arithmetic on a pointer to incomplete type<<type>>"

c "VOID_INVALID_USE", 101, "Invalid use of 'void'"
c "UNINITIALIZED_CONST_NEW", 102, "Uninitialized const in 'new'"
c "NEW_ARRAY_SIZE_CONSTANT", 103, "Array size in new-expression must be constant"

c "INVALID_DELETE_TYPE", 104, "type<<type>> argument given to 'delete', expected pointer"

c "UNINITIALIZED_REFEFENCE", 111, "'<<<id>>>' declared as reference but not initialized"


c "STRING_POINTER", 201, "String pointers are not supported"
c "STRING_ARRAY", 202, "String arrays are not supported"
c "STRING_ADDRESSING", 203, "String addressing is not supported"

c "TEMPORARY_ADDRESS_LIMIT", 301, "Temporary variable address space limit reached. You should simplify your program by breaking complex expressions into multiple operations"
c "MAX_STACK_SIZE_EXCEEDED", 302, "Function<<id>> with stack size <<<size>>> bytes exceeds the maximum stack size limit of <<<limit>>> bytes. Try moving array declarations to the global scope"
c "MAX_HEAP_SIZE_EXCEEDED", 303, "Heap size of <<<size>>> bytes exceeds the maximum <<<limit>>> bytes limit."

# Execution errors
e "DIVISION_BY_ZERO", 136, "Floating point exception: division by zero"
e "MODULO_BY_ZERO", 137, "Floating point exception: modulo by zero"

e "STACK_OVERFLOW", 138, "Stack overflow while calling function<<id>>. May be caused by infinite recursion, too deep recursion or very large local variable space"
e "TEMPORARIES_OVERFLOW", 139, "Run out of temporaries while calling function<<id>>. May be caused by too complex expressions or very deep or infinite recursion"
e "INVALID_NEW_ARRAY_LENGTH", 140, "Invalid negative array size to new operator"
e "CANNOT_ALLOCATE", 141, "Cannot allocate<<size>> bytes, not enough heap space left"
e "INVALID_FREE_POINTER", 142, "Used delete on an already deleted pointer or a pointer not allocated with new: <<pointer>>"