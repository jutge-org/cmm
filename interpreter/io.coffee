assert = require 'assert'

module.exports = class IO
    @stdout: ""
    @stderr: ""
    @interleaved: ""
    @STDIN: 0
    @STDOUT: 1
    @STDERR: 2

    @reset: ->
        IO.stdout = ""
        IO.stderr = ""
        IO.interleaved = ""

    @output: (stream, string) ->
        assert (typeof string is "string")
        @interleaved += string

        switch stream
            when IO.STDOUT
                IO.stdout += string
            when IO.STDERR
                IO.stderr += string
            else
                assert false
