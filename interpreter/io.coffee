assert = require 'assert'

module.exports = class IO
    @streams:
        1: ""
        2: ""
        0: ""
        3: ""

    @STDIN: 0
    @STDOUT: 1
    @STDERR: 2
    @INTERLEAVED: 3

    @stdoutCB: null

    @reset: ->
        for stream of IO.streams
            IO.streams[stream] = ""

    @output: (stream, string) ->
        assert (typeof string is "string")
        assert IO.streams[stream]?


        IO.streams[IO.INTERLEAVED] += string

        IO.streams[stream] += string
        IO.stdoutCB IO.streams[IO.STDOUT]

    @setInput: (stream, input) ->
        assert (typeof input is "string")
        assert IO.streams[stream]?

        IO.streams[stream] = input.trim().split(/\s+/)

        IO.streams[stream] = [] if IO.streams[stream][0] is ""

    @getWord: (stream) ->
        assert IO.streams[stream]?
        IO.streams[stream].shift()

    # Used to refill when there is some leftover that was not parsed from the word
    @unshiftWord: (stream, word) ->
        assert IO.streams[stream]?
        IO.streams[stream].unshift(word)

    @getStream: (stream) -> IO.streams[stream]

    @setStdoutCB: (cb) -> IO.stdoutCB = cb

    @isInputBufferEmpty: (stream) -> IO.streams[stream].length is 0
