$ -> # Equivalent to $(document).ready(function() {...})
    # Place the code editor
    codeMirror = CodeMirror(((elt) -> $("#code").replaceWith(elt)),
        {
            value:
                """
                    #include <iostream>
                    using namespace std;

                    int main() {
                      
                    }
                """
            theme: "material"
        }
    )

    w = null
    do resetWorker = ->
        w = new Worker("js/run.js")

        w.onmessage = (e) ->
            { data: { type, value }} = e
            if type is "status"
                $("#exitstatus").text(value)
            else
                $("#output").text(value)

    $("#compile").click(->
        w.postMessage({ command: "compile", code: codeMirror.getValue() })
    )

    $("#run").click(->
        w.postMessage({ command: "run", code: codeMirror.getValue(), input: $("#input").val() })
    )

    $("#kill").click(->
        $("#exitstatus").text("Killed")
        w.terminate()
        resetWorker()
    )
