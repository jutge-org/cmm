util = require 'util'

{ parser } = require '../../parser/grammar.jison'
{ checkSemantics } = require '../../semantics/'
interpreter = require '../../interpreter/'
Ast = require '../../parser/ast.coffee'

parser.yy = { Ast }

compile = (code) ->
    ast = parser.parse code
    checkSemantics ast


execute = (ast) ->
    interpreter.load ast
    interpreter.run()

setOutput = (s) -> $("#output").html(s)
setStatus = (s) -> $("#exitstatus").text(s)

$ -> # Equivalent to $(document).ready(function() {...})
    # Place the code editor
    codeMirror = CodeMirror(((elt) -> $("#code").replaceWith(elt)),
        {
            value:
                """
                    int main() {

                    }
                """
            theme: "material"
        }
    )

    $("#compile").click(->
        setOutput ""
        setStatus "Compiling"
        code = codeMirror.getValue()

        try
            ast = compile code
        catch error
            console.log error.stack
            setOutput "#{error.message}"
            setStatus "Compilation error"
            return

        setOutput "#{JSON.stringify(ast, null, 4)}"
        setStatus "Compiled"
    )

    $("#run").click(->
        code = codeMirror.getValue()

        try
            ast = compile code
        catch error
            setOutput "#{error.stack ? error.message}"
            setStatus "Compilation error"
            return

        setStatus "Running"

        try
            { stdout, stderr, output, status } = execute ast
        catch error
            setOutput "#{error.stack ? error.message}"
            return

        setStatus status
        setOutput output
    )
