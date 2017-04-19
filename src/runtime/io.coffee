assert = require 'assert'

module.exports = @

@IO = class IO
    @STDIN: 0
    @STDOUT: 1
    @STDERR: 2
    @INTERLEAVED: 3

    constructor: ->
        @streams =
            1: ""
            2: ""
            0: []
            3: ""

    output: (stream, string) ->
        assert (typeof string is "string")
        assert @streams[stream]?


        @streams[IO.INTERLEAVED] += string
        @streams[stream] += string

    setInput: (stream, input) ->
        assert (typeof input is "string")
        assert @streams[stream]?

        @streams[stream] = input.trim().split(/\s+/)

        @streams[stream] = [] if @streams[stream][0] is ""

    getWord: (stream) ->
        assert @streams[stream]?
        @streams[stream].shift()

    # Used to refill when there is some leftover that was not parsed from the word
    unshiftWord: (stream, word) ->
        assert @streams[stream]?
        @streams[stream].unshift(word)

    getStream: (stream) -> @streams[stream]
