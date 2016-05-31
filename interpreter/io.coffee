assert = require 'assert'

module.exports = class IO
    @stdout: ""
    @stderr: ""
    @STDIN: 0
    @STDOUT: 1
    @STDERR: 2

    @reset: ->
        IO.stdout = ""
        IO.stderr = ""

    @output: (stream, string) ->
        assert (typeof string is "string")

        switch stream
            when IO.STDOUT
                IO.stdout += string
            when IO.STDERR
                IO.stderr += string
            else
                assert false
