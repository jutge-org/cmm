# Test format

All tests are C++ programs. They are contained in a C++ file with .cc extension, and their expected behaviour is
specified in a header.

## Header format

The header must be placed at the beggining of the program source file, inside a multiline comment (/* ... */)

The properties of the test are described using a pseudo-json format:

/*

description{This test prints 'Hello World'}
compilation-error{0}
status{0}

*/

The description field contains a description of what the test does. The compilation-error field indicates the expected
compilation error code of the program. It is optional and a value of 0 or the property missing indicates that no compilation
error is expected. The status field indicates the expected exit status code of the program after its execution.

## Input/Output

Every test can optionally have one or multiple input->output sets. For a test named my-test.cc, the input files must follow
the format my-test[-*].in, and the expected output file associated with that input must be named
exactly as the input file but with the .out extension instead. If an output file has no input file associated with it,
the input of the program will be empty. If an input file has no output file associated with it, the output
is not checked. The same happens when a program has neither input or output, the input is assumed to be empty and the output is not checked.

## Organization

Tests can be contained inside folders. If a test is named program.cc, then it inherits the name from its parent folder.
Similarly, if an input or output file does not match any other test inside the folder it is assumed to belong to
the program.cc test. This means that input/output files associated with the program.cc test don't need to have any particular
format, except for the associations between the input and the output files.