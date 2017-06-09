assert = require 'assert'

{ Message } = require './message'

@invalidArithmetic = {
    DIVISION_BY_ZERO:
        code: 136
        message: "Floating point exception: division by zero"
        description: """
            This error occurs when performing an integer division with a zero-valued divisor.

            Example:

            ```
                int main() {
                    int x = 2;

                    x *= 0;

                    x /= x; // Error! x is zero because of the previous operation, so we're dividing by zero
                }
            ```
        """

    MODULO_BY_ZERO:
        code: 137
        message: "Floating point exception: modulo by zero"
        description: """
            This error occurs when performing a modulo with a zero-valued modulo.

            Example:

            ```
                int main() {
                    int x = 2;

                    x *= 0;

                    x %= x; // Error! x is zero because of the previous operation, so we're performing a modulo by zero
                }
            ```
        """
}


@overflow = {
    STACK_OVERFLOW:
        code: 138
        message: "Stack overflow while calling function<<id>>. May be caused by infinite recursion, too deep recursion or very large local variable space"
        description: """
            This error can be caused either by too large local variables, or by too deep (possibily infinite) recursion.

            Example:

            ```
                int f() { // f recurses forever, and it has a very large local variable 'arr', so it will eventually cause a stack overflow
                          // note that the first condition is sufficient to cause a stack overflow
                    int arr[500][500][500];

                    f();
                }

                int main() {
                    f();
                }
            ```
        """

    TEMPORARIES_OVERFLOW:
        code: 139
        message: "Ran out of temporaries while calling function<<id>>. May be caused by too complex expressions or very deep or infinite recursion"
        description: """
            This error can be caused either by too complex expressions or by to deep (possibily infinite) recursion.

            If you happen to receive this error, try to simplify expressions in your program by breaking them
            into multiple simpler expressions in different lines. Also check that there is no infinite recursion in your program.
        """
}


@allocationAndDeallocation = {
    INVALID_NEW_ARRAY_LENGTH:
        code: 140
        message: "Invalid negative array size to new operator"
        description: """
            This error occurs when using new on an array type with a variable first dimension that happens to evaluate to
            a negative integer at runtime.

            Example:

            int f() {
                return -1;
            }

            ```
                int n = f();

                int* p = new int[n]; // Error! n is negative here

            ```
        """

    CANNOT_ALLOCATE:
        code: 141
        message: "Cannot allocate<<size>> bytes, not enough heap space left"
        description: """
            This error occurs when allocating too large arrays. It could be that your program has already
            allocated too much space previously or that the static heap (global variables) is too big.

            Example:

            ```
                int x[500][500]; // Big global variable

                void f(int n) {
                    if (n > 0) {
                        int * p = new int[50][50][50]; // This is executed 1000 times, causing too many allocations and exhausting the heap space
                        f(n - 1);
                    }
                }

                int main() {
                    f(1000);
                }

            ```
        """

    INVALID_FREE_POINTER:
        code: 142
        message: "Used delete on an already deleted pointer or a pointer not allocated with new: <<pointer>>"
        description: """
            This error occurs when using delete on a pointer or array which has not been previously allocated with new,
            or a pointer which has already been freed with delete before in the program.

            Example:

            ```
                int x;

                int main() {
                    int* p = &x;

                    delete p; // Error! p has not been allocated with new

                    int * p2 = new int[20];

                    delete p2; // Correct, p2 has been allocated with new

                    delete p2; // Error! p2 has already been freed with delete before
                }
            ```
        """
}

e = (name, code, message, description) =>
    assert not module.exports[name]?, "Execution error #{name} already in use"

    for messageName, messageObject of module.exports
        assert messageObject.code isnt code, "Execution error code #{code} for #{name} already in use by #{messageName}"

    new Message code, message + "\n", "Execution error", description

module.exports = {}

for errorType, map of @
    for name, { code, message, description } of map
        module.exports[name] = e(name, code, message, description)


