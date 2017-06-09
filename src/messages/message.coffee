assert = require 'assert'

utils = require '../utils'

module.exports = @

@Message = class Message
    constructor: (@code, @message, @type, @description) ->
        @generated = yes
        @locations = null

    complete: (placeHolder, text, others...) ->
        others.unshift(placeHolder, text)
        ret = utils.clone this

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

    toString: (code) ->
        if @locations?
            { lineColumnSpec, relevantCode } = utils.locationsMessage code, @locations
        else
            lineColumnSpec = ""

        message =
            if @code is 1001 # Parse error
                @message
            else
                "#{lineColumnSpec}semantic error: #{@message}"

        s = message + "\n"

        s += utils.indent(relevantCode, 2) + "\n" if relevantCode?

        s += "\nDescription:\n\n#{@description}" if @description?

        s