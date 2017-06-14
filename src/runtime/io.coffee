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

        @listeners = {}

        @listeners[stream] = [] for stream of @streams

    output: (stream, string) ->
        assert (typeof string is "string")
        assert @streams[stream]?

        @streams[IO.INTERLEAVED] += string
        @streams[stream] += string

        listener(string) for listener in @listeners[stream]
        listener(string) for listener in @listeners[IO.INTERLEAVED]

    input: (stream, input) ->
        assert (typeof input is "string")
        assert @streams[stream]?

        words = input.trim().split(/\s+/)

        if words.length and words[0].length
            @streams[stream] = @streams[stream].concat(words)

    getWord: (stream) ->
        assert @streams[stream]?
        @streams[stream].shift()

    # Used to refill when there is some leftover that was not parsed from the word
    unshiftWord: (stream, word) ->
        assert @streams[stream]?
        @streams[stream].unshift(word)

    getStream: (stream) -> @streams[stream]

    setOutputListeners: (listeners) ->
        for { fn, stream } in listeners
            assert stream of @streams
            @listeners[stream] ?= []
            @listeners[stream].push fn
