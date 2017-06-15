[![Build Status](https://travis-ci.org/jutge-org/cmm.svg?branch=master)](https://travis-ci.org/jutge-org/cmm)

# C--

C-- is a C++ interpreter that can be embedded in the browser.

The project is in early stages, so things may go wrong.

## [Try it!](http://c--lang.ml/)

## Supported language features

* **Primitive types**: `int`, `double`, `char`, `bool`
* **Compound types**: **Arrays** (static size), **pointers**
* **Strings** *(partially, they are immutable, individual characters cannot be accessed and they cannot be passed as function arguments)*
* **Variable declaration** and **assignment**
* **Arithmetic operators**: binary `+`,`-`,`\*`,`/`,`%`, unary `+`,`-`
* **Logic operators**: binary `&&`,`||`, unary `!` together with their aliases `and`,`or`,`not`
* **Comparison operators**:  `==`, `!=`, `>`, `>=`, `<`, `<=`
* **Dereferencing** (unary `*` operator), **addressing** (unary `&` operator) and **subscripting** (`[]` operator)
* `while` and `for` loops
* `if`, `if`-`else` statements
* **Functions** (including void functions, and return statement)
* **Global variables**
* **Const** specifier
* `new` and `delete` operators
* `cin` and `cout` (partially, they are simulated as language constructs instead of using objects and operator overloading as in C++)

## Other features

* Step-by-step execution, the program can be paused and resumed as desired
* Debugger API

## How it works

1. The program is parsed using a parser produced with the jison parser generator, which generates an AST
2. The AST is semantically analised
3. Each variable is mapped into a memory address. Memory is simulated
using Javascript Typed Arrays, with heap and stack memory 'compartments'
4. A list of instructions is produced for each function
5. The list of instructions is interpreted one by one


## Command Line Interface

### Installation

[npm](https://www.npmjs.com/), [node](https://nodejs.org/en/) and [coffeescript](http://coffeescript.org/) are required to run `cmm`.

Once these are installed, run `npm install` and `chmod +x cmm`, and you're all set.

### Usage

`cmm [program-path] [input-path]`

1. Compiles the program specified in `program-path` (or a hello world program in its defect), printing its AST and
list of instructions. Gives compilation errors in case they occur.

2. If compilation is successful, runs the program with the input specified in `input-path` (or empty input otherwise) and prints the stdout and interleaved(stdout + stderr) outputs from the execution.

## Embedding in the browser

[gulp](http://gulpjs.com/) is required to build the project into a single `.js` file.

Run `npm install` followed by `gulp`. The resulting `.min.js` and `.js` files are written inside the `build` directory.

Now you can include this `.js` file in the browser and access the C-- interface by using the `cmm` object exported.

Example usage:

```Javascript
var compiled = cmm.compile "int main() { int n; cin >> n; cout << n; }";

var ast = compiled.ast; // Can be printed with console.log(ast.toString())
var program = compiled.program; // Instructions can be printed with program.writeInstructions()

var execResult = cmm.runSync(program, "2");

var stdout = execResult.stdout; // "2"
var stderr = execResult.stderr; // "" (Non empty in case of execution errors such as stack overflow or division by zero)
var output = execResult.output; // "2" (Combination of stdout and stderr)
var status = execResult.status; // Value returned by main, in this case 0

// Step by step execution
var iterator = cmm.run(program, "2");

vm = iterator.next().value; // vm holds the execution status right before the first instruction execution

while (!vm.finished) {
    vm = iterator.next().value; // vm holds the execution status right after the 1st, 2nd, ... instruction execution
}

// vm at this point is exactly equal to execResult in the synchronous example
```

## Using as an npm package

Use the same exact steps above and instead of including the file in the browser require the resulting `index.js` file.

```Javascript
var cmm = require('path-to-index.js');

// Use cmm as in the previous example
```
