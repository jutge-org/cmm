assert = require 'assert'

module.exports = @

@Message = class Message
    constructor: (@code, @message, @type, @description) ->
        @generated = yes

    complete: (placeHolder, text, others...) ->
        others.unshift(placeHolder, text)
        ret = new Message @code, @message, @type, @description

        while others.length > 0
            [placeHolder, text, others...] = others
            bracedPlaceHolder = "<<<#{placeHolder}>>>"

            index = ret.message.indexOf bracedPlaceHolder
            isLiteral = index >= 0

            unless isLiteral
                bracedPlaceHolder =  "<<#{placeHolder}>>"
                index = ret.message.indexOf bracedPlaceHolder
                text = if text? then " '#{text}'" else " "

            assert index >= 0
            assert text?

            ret.message = ret.message.replace bracedPlaceHolder, text

        ret