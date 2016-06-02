{ parser } = require '../../parser/grammar.jison'
{ checkSemantics } = require '../../semantics/'
interpreter = require '../../interpreter/'
Ast = require '../../parser/ast.coffee'

parser.yy = { Ast }

compile = (code, showAst = no) ->
    setOutput ""
    setStatus "Compiling"

    try
        ast = parser.parse code
        ast = checkSemantics ast
    catch error
        console.log(error.stack ? error.message ? error)
        setOutput "#{error.message}"
        setStatus "Compilation error"
        return

    setOutput "#{JSON.stringify(ast, null, 4)}" if showAst
    setStatus "Compiled"
    ast


execute = (ast, input) ->
    setStatus "Running"

    try
        interpreter.load ast
        { stdout, stderr, output, status } = interpreter.run(input)
    catch error
        console.log(error.stack ? error.message ? error)
        setOutput "#{error.stack ? error.message}"
        return

    setStatus status
    setOutput output


setOutput = (s) -> postMessage({ type: "output", value: s })
setStatus = (s) -> postMessage({ type: "status", value: s })

onmessage = (e) ->
    { data: { command, code, input } } = e

    if command is "compile"
        compile(code, yes)
    else
        ast = compile(code)
        if ast?
            execute(ast, input)
