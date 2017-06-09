assert = require 'assert'

{ Message } = require './message'

@parsing = {
    PARSING_ERROR:
        code: 1001
        message: "Parsing error:\n<<<error>>>"
}


@declaration = {
    VARIABLE_REDEFINITION:
        code: 2001
        message: "Cannot define variable or function<<name>>: already defined in this scope" # TODO: Indicate type of each variable (function, variable...) for redeclaration and initial declaration, and show the line/column of each declaration
        description: """
            This error occurs when two variables are declared with the same exact name within the same scope.

            It could be caused by a clash between two function names, for instance:

            ```
                int myFunction() { // First definition
                }

                ...

                double myFunction() { // Error! myFunction name is already used in the first definition
                }
            ```

            Or a function and a global variable:

            ```
                int x; // First global variable definition

                ...

                double x() { // Error! x name is already used in the first global variable definition
                }
            ```

            Or by two local variables:

            ```
                int main() {

                    int p; // First definition of p as int

                    if (true) {
                        double p; // This compiles, although not recommended, the scope is different because
                                  // every { } pair opens a new scope so further uses of p within this scope
                                  // all refer to this 'double p' instead of 'int p'
                    }

                    char p; // Error! p is already defined in this scope as an int
                }
            ```

            Remember that scopes are delimited by the '{' and '}' symbols.
        """

    VOID_FUNCTION_ARGUMENT:
        code: 2002
        message: "Cannot define a function argument with 'void' type: function<<function>>, argument<<argument>>"
        description: """
            Function arguments should not have type 'void'.

            Example:

            ```
                void f(void x) { // Wrong! return type can be void but argument x cannot be declared as void

                }

                void fCorrect() { // If you want to declare a function with no arguments it should be declared like this

                }

                void fCorrect2(void) { // Or like this, which is equivalent to the declaration of 'fCorrect'

                }
            ```
        """

    ARRAY_OF_FUNCTIONS:
        code: 2003
        message: "Declaration of<<id>> as array of functions"
        description: """
            This error occurs when trying to declare a function with an array return type. Functions
            cannot return arrays, pointers should be used instead as the return type. Also, arrays of functions
            are not allowed either, so this alternative interpretation is not correct either.

            Example:

            ```
                int f[2]() { // f[2] is not allowed here, f is a function and cannot return an array int[2] f() {} would also be incorrect

                }
            ```
        """


    NO_RETURN_TYPE:
        code: 2004
        message: "Function declared with no return type"
        description: """
            This error occurs when no type has been specified in the return section of a function declaration.

            Example:

            ```
                const f() { // Wrong! const is not a type and no return type has been specified for f
                }
            ```
        """

    VOID_DECLARATION:
        code: 2005
        message: "Variable or field<<name>> declared void"
        description: """
            This error occurs when declaring a variable or field with void type.

            Example:

            ```
                int main() {
                    void x; // Wrong! a variable cannot have type void
                }
            ```
        """

    INVALID_ARRAY_DECLARATION_TYPE:
        code: 2006
        message: "Cannot declare<<name>> as array of<<type>>"
        description: """
            This error occurs when declaring arrays of an invalid type such as void.

            Example:

            ```
                int main() {
                    void arr[20]; // Error! Cannot declare an array of void values
                }
            ```
        """

    DUPLICATE_SPECIFIER:
        code: 2007
        message: "Duplicate specifier<<specifier>> for declaration"
        description: """
            This error occurs when a variable, member or function declaration has more than one specifier,
            such as a const or a type specifier;

            Example:

            ```
                const int const x; // Wrong! duplicate const specifier
                int double y; // Wrong! duplicate type specifier
            ```
        """

    NO_TYPE_SPECIFIER:
        code: 2008
        message: "No type specifier for declaration"
        description: """
            This error occurs when a variable or member declaration has no type specifier.

            Example:

            ```
                int main() {
                    const x = 2; // Error! no type specifier for declaration of 'x'
                }
            ```
        """

    ALL_BOUNDS_EXCEPT_FIRST:
        code: 2009
        message: "Multidimensional array<<id>> must have bounds for all dimensions except the first"
        description: """
            This error occurs when declaring an array variable or function parameter without specifying the size of
            the dimensions. All but the first dimension must be specified in a function parameter declaration, and all
            the dimensions must be specified in a variable or member declaration.

            Example:

            ```
                int f(int arr[20][]) { // Wrong! second dimension of parameter arr is not specified
                }

                int main() {
                }

            ```
        """

    STORAGE_UNKNOWN:
        code: 2010
        message: "Storage size of<<id>> isn't known"
        description: """
            This error occurs when declaring array variables or members and not specifying one or more of its dimensions.

            Example:

            ```
                int arr[][20]; // Error! first dimension not specified for declaration of 'arr'

            ```
        """

    POINTER_UNBOUND_SIZE:
        code: 2011
        message: "Parameter<<id>> includes pointer to array of unknown bound<<type>>"
        description: """
            This error occurs when defining a function parameter as a pointer to an array which has one of its dimensions
            as unspecified.

            Example:

            ```
                int f(char (*arr)[]) { // Error! parameter arr is declared as a pointer to an array with unknown size (first dimension unknown)
                }

            ```
        """

    ARRAY_SIZE_NEGATIVE:
        code: 2012
        message: "Size of array<<id>> is negative"
        description: """
            This error occurs when declaring an array and specifying one of its dimensions with negative size.

            Example:

            ```
                int arr[-2]; // Wrong! First dimension of arr is negative
            ```
        """

    STATIC_SIZE_ARRAY:
        code: 2013
        message: "Invalid array dimension value for array<<id>>, only literals are supported as array dimensions" # TODO: Support const variables and static values
        description: """
            This error occurs when declaring an array and specifying one of its dimensions with something other than
            an integral literal. Even const integer variables or static expressions are not supported in the current
            version of the compiler, but will be supported in the future.

            Example:

            ```
                const int X = 2;

                int arr[X]; // Error! X is not a literal but a variable

                int arr2[10]; // Correct, size is literal
            ```
        """

    NONINTEGRAL_DIMENSION:
        code: 2014
        message: "Size of array<<id>> has non-integral type<<type>>"
        description: """
            This error occurs when an array is declared with a dimension value having a non-integral type, such as double.

            Example:

            ```
                int arr[2.5]; // Error! Size is not integral

            ```
        """

    STRING_ARRAY:
        code: 2015
        message: "String arrays are not supported"
        description: """
            This error occurs when declaring an array of strings, which is not supported yet.

            Example:

            ```
                string arr[20]; // Error! declaring an array 'arr' of strings
            ```
        """

    STRING_ARGUMENT:
        code: 2016
        message: "String function arguments are not supported"
        description: """
            This error occurs when declaring a function argument with string type. This feature is not supported yet.

            Example:
            ```
                int f(string s) { // Error! s declared as a string argument
                    ...
                }
            ```
        """

    STRING_POINTER:
        code: 2017
        message: "String pointers are not supported"
        description: """
            This error occurs when declaring a pointer to type string. Currently pointer to string declarations
            are not supported.

            Example:

            ```
            string * x; // Error! Declaring pointer to string

            ```
        """
}

@variableUse = {
    REF_VARIABLE_NOT_DEFINED:
        code: 3001
        message: "Cannot reference variable<<name>>: not defined in this scope"
        description: """
            This error occurs when trying to read or write on a variable which has not been declared in the same
            scope of use or any parent scope.


            Example:

            ```
                int main() {
                    if (true) {
                        int x;

                        ... // do something with x
                    }


                    x = 3; // Error! x has not been declared in this scope or the parent scope, its
                           // declaration is within a children scope created by the if statement,
                           // and thus it is not visible here
                }
            ```
        """
}

@functionCalling = {
    CALL_FUNCTION_NOT_DEFINED:
        code: 4001
        message: "Cannot call function<<name>>, has not been declared"
        # TODO: Add function prototypes solution when they are implemented
        description: """
            This error occurs when calling a function which has not been defined before the call.

            Example:

            ```
                int f() {
                    ...
                    t(); // Wrong! t has not been defined yet, its definition comes after its use
                    ...
                }


                int t() {
                    ...
                }
            ```
        """

    CALL_NON_FUNCTION:
        code: 4002
        message: "Cannot call variable<<name>>, which is not a function" # TODO: Should show line/column where the variable which is not a function is declared
        description: """
            This error occurs when trying to call on a variable which is not a function. It could be caused
            by variable shadowing, as you can see in the example.

            Example:

            ```
                int f() {
                    ...
                }

                int main() {
                    ...
                    double f = 2; // Redefines f and shadows the function

                    f(); // Error! Here f refers to the variable, not the function, and a variable cannot be called.
                }
            ```
        """

    INVALID_PARAMETER_COUNT_CALL:
        code: 4003
        message: "Function<<name>> with<<good>> parameters has been called with wrong number of parameters<<wrong>>"
        description: """
            This error is caused when calling a function with too few parameters or too much parameters.

            Example:

            int f0() {
            }

            int f2(int a, int b) {
            }

            int main() {
                int x, y;

                f0(x); // Error, f has 0 parameters, called with 1 parameter

                f2(); // Error, f2 has 2 parameters, called with 0 parameters

                f2(x, y); // Correct, f2 has 2 parameters, called with 2 parameters
            }
        """
}

@assignment = {
    ASSIGN_OF_NON_ASSIGNABLE:
        code: 5001
        message: "Variable<<id>> with type<<type>> is not assignable"
        description: """
            This error occurs when trying to assign to a variable which has a non-assignable type, such as
            a function variable.


            Example:

            ```
                int f() {
                }

                int f2() {
                }

                int main() {
                    f = f2; // Error! functions are not assignable
                }
            ```
        """

    LVALUE_ASSIGN:
        code: 5002
        message: "lvalue required as left operand of assignment"
        description: """
            This error occurs when trying to assign to an expression which is not necessarily stored in memory,
            such as a literal or the result of an expression which does not refer to a memory location.

            Example:

            ```
                int main() {
                    int a;

                    int* p;

                    2 = 5; // Error, 2 is a literal not a variable

                    a + 2 += 3; // Error, a + 2 is not a variable, it's the result of an arithmetic expression which does not refer to a memory location. Note that += is also a type of assignment

                    *(p + 2) = 5; // Correct, in this case p + 2 is a pointer, and its dereference (*) refers to a memory location

                    ++a = 3; // Also correct, although highly discouraged. In this case the expression is equivalent to a = 3
                }
            ```
        """

    ASSIGN_TO_ARRAY:
        code: 5003
        message: "Invalid array assignment"
        description: """
            This error occurs when trying to assign something to an array instead of one of its elements.

            Example:

            ```
                int arr[20][30];

                int arr2[20][30];

                int main() {
                    arr = arr2; // Error! Even if both arrays have the same type and sizes, array assignment is not allowed

                    arr[0] = arr2[0]; // Error! Same as above, arr[0] returns an a int[30] array, which is again not assignable

                    arr[0][0] = arr2[0][1]; // Correct, arr[0][0] is a specific memory location, not an array
                }
            ```
        """

    CONST_MODIFICATION:
        code: 5004
        message: "Modification of read-only variable<<name>>"
        description: """
            This error occurs when trying to assign on to a variable which has been declared const.

            Example:

            ```
                const int SIZE = 2;

                int main() {
                    SIZE = 3; // Error! SIZE is declared const, cannot be modified
                }
            ```
        """
}

@arrays = {
    INVALID_ARRAY_SUBSCRIPT:
        code: 6001
        message: "Invalid types '<<<type>>>[<<<typeSubscript>>>]' for array subscript"
        description: """
            This error occurs when trying to use an array subscript on something which is not an array or pointer,
            or using a subscript value which is not a integral value (char, bool or int).

            Example:

            ```
                int main() {
                    int arr[20];
                    int x;

                    x[0] = 2; // Error! x is not an array so it cannot be subscripted on 0

                    x = arr[2.6]; // Error! 2.6 is not an integral value so it cannot be used as a subcript value
                }

            ```
        """
}

@cin = {
    LVALUE_CIN:
        code: 7001
        message: "lvalue required as operand of cin"
        description: """
            This error occurs when trying to cin on an expression which does not represent a memory location,
            such as a literal or a conventional arithmetic expression.

            Example:

            ```
                #include <iostream>
                using namespace std;

                int main() {
                    int a;

                    cin >> (a + 2); // Error! a + 2 is not necessarily stored in a memory location

                    cin >> 2; // Error! 2 is a literal, not necessarily in a memory location

                    cin >> a; // Correct, a is stored in a memory location
                }
            ```
        """

    INVALID_CIN_OPERAND:
        code: 7002
        message: "Invalid operand of type<<type>> to cin"
        description: """
            This error occurs when using cin with a variable type that is not adequate for the operation,
            such as pointers, arrays or functions.

            Example:

            ```
                #include <iostream>
                using namespace std;

                int main() {
                    int* p;
                    int arr[2];
                    int x;

                    cin >> p // Error! p is a pointer, cin is not allowed on pointers
                        >> arr // Error! arr is an array, cin does not support arrays
                        >> main // Error! main is a function, cin does not support functions
                        >> arr[0]; // Correct, arr[0] is of type int, which is supported by cin
                }
            ```
        """
}

@expressions = {
    INVALID_OPERANDS:
        code: 8001
        message: "Invalid operands<<typel>> and<<typer>> to operation" # TODO: Should specify which operation is being applied
        description: """
            This error occurs when trying to apply a binary operation to arguments of incorrect type,
            for instance adding up two pointers (or arrays), or multiplying a pointer or array by a number. Other kinds of operations
            which are not allowed, such as multiplying a string by a number or adding a string to a number
            throw a different kind of error, because the compiler tries to cast the wrong argument type to the adequate
            type, failing to do so. In the case of pointers the cast cannot even be tried so this type of error is thrown.

            Example:
            ```
                int main() {
                    int* p;

                    int arr[2];

                    p = p + p; // Incorrect! cannot add up two pointers

                    int x = arr*2; // Incorrect! cannot multiply an array by an integer

                    int* p2 = p + 1; // Correct, adding a pointer to an integer is allowed
                }
            ```
        """

    WRONG_ARGUMENT_UNARY_MINUS:
        code: 8002
        message: "Wrong type argument<<type>> to unary minus"
        description: """
            This error occurs when trying to apply the unary minus operation to invalid types
            such as pointers or arrays.
            
            Example:

            ```
                int main() {
                    int arr[2];
                    int * p;

                    -p; // Error! Argument type pointer is not allowed for -

                    -arr; // Error! Argument type array is not allowed for -

                }
            ```
        """

    NON_INTEGRAL_MODULO:
        code: 8003
        message: "Both operands to modulo operation must be integrals"
        description: """
            This error occurs when performing a modulo operation with an operand being of non-integral type,
            such as double.

            Example:

            ```
                int main() {
                    int x = 2;
                    double y = 2.0;

                    int m  = x%y; // Wrong! Both operands must be of integral type but 'y' isn't
                }

            ```
        """


    INVALID_BOOL_DEC:
        code: 8004
        message: "Invalid use of boolean expression as operand to 'operator--'"
        description: """
            This error occurs when trying to decrement a variable of boolean type.

            Example:

            ```
                int main() {
                    bool x;
                    --x; // Wrong! Booleans cannot be pre-decremented
                    x--; // Wrong! Booleans cannot be post-decremented
                }

            ```
        """

    LVALUE_ADDRESSING:
        code: 8005
        message: "Lvalue required as unary '&' operand"
        description: """
            This error occurs when trying to use the unary '&' operand (address of) on an operand
            which is not necessarily stored in a memory location.

            Example:

            ```
                int f() {
                    return 5;
                }

                int main() {
                    int y;

                    int* x = & (f()); // Wrong! the return value of f() is not necessarily stored in memory, cannot be addressed

                    int* p = & (&y); // Wrong! &y gives a value which is not necessarily stored in memory, because it is a variable address
                }
            ```
        """

    UNALLOWED_ARITHMETIC_INCOMPLETE_TYPE:
        code: 8006
        message: "Cannot perform pointer arithmetic on a pointer to incomplete type<<type>>"
        description: """
            This error occurs when trying to perform pointer arithmetic on a pointer to incomplete type.
            An example of an incomplete type is an array whose first dimension size is not bounded.

            Example:

            ```
                int main() {
                    int (*arr)[];

                    ++arr; // Error! arr is a pointer to an array with unknown first dimension
                }
            ```
        """

}

@types = {
    VOID_NOT_IGNORED:
        code: 9001
        message: "Void value not ignored as it ought to be"
        description: """
            This error occurs when trying to assign a value with void type, for instance the result of a
            void function call or the dereference of a void*

            Example:

            ```
                void f() {
                }

                int main() {
                    void* p;

                    int a = *p; // Error! *p has void type, cannot be assigned

                    int b = f(); // Error! f() has void type, cannot be assigned
                }
            ```
        """

    INVALID_CAST:
        code: 9002
        message: "Cannot cast type<<origin>> to type<<dest>>"
        description: """
            This error occurs when some operation that you perform requires a type different than
            the one you specified, thus a casting to the desired type is required for the operation to proceed,
            but the type that you specified cannot be casted to the specified type.

            This could happen in an arithmetic operation, comparison, assignment, function parameter forwarding,
            etc.

            Example:

            ```
                int f(int x) {
                }

                int main() {
                    string s;
                    int* p;

                    int x = s; // Error! s with type string cannot be casted to type int

                    f(p); // Error! f expects an argument of type int but pointer was passed, and pointer cannot be casted to int

                    int x = 2 + "string"; // Error! binary + expects operands to have same numerical type, but "string" with type string cannot be casted to type int
                }

            ```
        """

    ASSIGNABLE_ADDRESSING:
        code: 9003
        message: "Assignable type required for unary '&' operand"
        description: """
            This error occurs when trying to take the address of some expression which doesn't have assignable type,
            such as void or function.

            Example:

            ```
                int main() {
                    int* x = &main; // Wrong! main is a function
                }
            ```
        """

    INVALID_DEREFERENCE_TYPE:
        code: 9004
        message: "invalid type argument of unary '*' (have<<type>>)"
        description: """
            This error occurs when trying to dereference an expression which is not a pointer or array.

            Example:

            ```
                int main() {
                    int x;

                    int y = *x; // Wrong! x doesn't have pointer or array type
                }
            ```
        """

    VOID_INVALID_USE:
        code: 9005
        message: "Invalid use of 'void'"
        description: """
            This error occurs when using a void type somewhere it is not expected. This can
            happen for instance when using the new operator with a void type argument.

            Example:

            ```
                int main() {
                    void* x = new void; // Wrong! void is not allowed here
                }

            ```
        """

    INVALID_DELETE_TYPE:
        code: 9006
        message: "type<<type>> argument given to 'delete', expected pointer or array"
        description: """
            This error occurs when using delete on an expression which doesn't have a pointer or array type.

            Example:

            ```
                int main() {
                    int x;

                    delete x; // Error! x has int type, which is not a pointer type
                }
            ```
        """


    STRING_ADDRESSING:
        code: 9007
        message: "String addressing is not supported"
        description: """
            This error occurs when using the unary & operator on strings or using new on a string type.

            Example:

            ```
                int main() {
                    string s;

                    &s; // Error! s has type string

                    new string; // Error! new cannot be applied to string type or string arrays
                }

            ```
        """

    POINTER_COMPARISON_DIFFERENT_TYPE:
        code: 9008
        message: "Comparison between distinct pointer types<<typeL>> and<<typeR>> is not allowed."
        description: """
            This error occurs when trying to compare to pointers which have different type.

            Example:

            ```
                int main() {
                    int* x;

                    const int* z;

                    double* y;

                    bool b = x == y; // Error! x and y have different pointer types

                    bool b2 = x == z; // Correct, x and y have same pointer type (constness doesn't matter)
                }
            ```
        """
}

@general = {

    MAIN_NOT_DEFINED:
        code: 10001
        message: "You must define a main function"
        description: """
            This error occurs when your program does not define a main function.

            Example:

            ```
                int mainf() { // typo, should be main, not mainf

                }

                // Main function is not defined anywhere in the program
            ```
        """

    INVALID_MAIN_TYPE:
        code: 10002
        message: "Main must return int"
        description: """
            This problem occurs when a main function is defined, but does not have int as its return type.

            Example:

            ```
                void main() { // Incorrect! main must have int return type, any other type is not allowed
                }
            ```
        """


}

@cout = {
    CANNOT_COUT_TYPE:
        code: 11001
        message: "Cannot cout value with type<<type>>"
        description: """
            This error occurs when using cout on an expression which cannot be written to the console.

            Types which cannot be written to the console: Function, nullptr_t, void

            Example:

            ```
                #include <iostream>
                using namespace std;

                void f() {
                }

                int main() {
                    cout << f; // Invalid! f is of type function

                    cout << f(); // Invalid! f() is of type void
                }

            ```
        """
}


@newOperator = {

    UNINITIALIZED_CONST_NEW:
        code: 12001
        message: "Uninitialized const in 'new'"
        description: """
            This error occurs when using new on a const type. Currently new initialization is not supported yet
            so any new declaration with a const type will give this error.

            Example:

            ```
                int main() {
                    const int * x = new const int; // Error! new const int is a const type and it's not initialized
                }
            ```
        """

    NEW_ARRAY_SIZE_CONSTANT:
        code: 12002
        message: "Array size in new-expression must be constant"
        description: """
            This error occurs when using a new statement on an array type which has a dimension other than the first one
            with a non-const value.

            Example:

            ```
                int main() {
                    int n = 5;

                    int** x = new int[20][n]; // Error! second dimension has non-constant value n

                    int (*x)[20] = new int[n][20]; // Correct, first dimension is allowed to have a non-constant value
                }
            ```
        """
}

@limits = {
    TEMPORARY_ADDRESS_LIMIT:
        code: 13001
        message: "Temporary variable address space limit reached. You should simplify your program by breaking complex expressions into multiple operations"
        description: """
            This error occurs when a program has very complex expressions, and it is very rare.

            If you happen to receive this error, try to simplify expressions in your program by breaking them
            into multiple simpler expressions in different lines.
        """

    MAX_STACK_SIZE_EXCEEDED:
        code: 13002
        message: "Function<<id>> with stack size <<<size>>> bytes exceeds the maximum stack size limit of <<<limit>>> bytes. Try moving array declarations to the global scope"
        description: """
            This error occurs when you define very big local variables inside a function. Typically it is
            due to declaring big arrays.

            Example:

            ```
                int main() {
                    int arr[5000][5000][5000]; This array occupies 5000*5000*5000*4 bytes = 100GB, which is way above the stack limit
                }
            ```
        """

    MAX_HEAP_SIZE_EXCEEDED:
        code: 13003
        message: "Heap size of <<<size>>> bytes exceeds the maximum <<<limit>>> bytes limit."
        description: """
            This error occurs when you define a very big global variable. Typically it is due to declaring big arrays.

            Example:

            ```
                int arr[5000][5000][5000]; This array occupies 5000*5000*5000*4 bytes = 100GB, which is way above the heap limit

            ```
        """
}

c = (name, code, message, description) =>
    assert not module.exports[name]?, "Compilation error #{name} already in use"

    for messageName, messageObject of module.exports
        assert messageObject.code isnt code, "Compilation error code #{code} for #{name} already in use by #{messageName}"

    new Message code, message, "Compilation error", description

module.exports = {}

for errorType, map of @
    for name, { code, message, description } of map
        module.exports[name] = c(name, code, message, description)


#c "IOSTREAM_LIBRARY_MISSING", 18, "<<name>> not found. iostream library needed." # Not in use right now


