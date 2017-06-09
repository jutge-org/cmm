module.exports = @

@clone = clone =  (x) ->
    if Array.isArray x
        x[...]
    else if typeof x is "object"
        r = {}
        r[key] = value for key, value of x
        r[key] = value for own key, value of x

        r
    else
        x

@max = ([first, rest...], f) ->
    if typeof f is "object"
        obj = f
        f = (x) -> obj[x]
    else if typeof f is "string"
        prop = f
        f = (x) -> x[prop]

    maxV = f first
    maxE = first

    for elem in rest
        if (v = f elem) > maxV
            maxE = elem
            maxV = v

    { arg: maxE, value: maxV }

@cloneDeep = (obj) ->
    if not obj? or typeof obj isnt 'object'
        return obj

    if obj instanceof Date
        return new Date(obj.getTime()) 

    if obj instanceof RegExp
        flags = ''
        flags += 'g' if obj.global?
        flags += 'i' if obj.ignoreCase?
        flags += 'm' if obj.multiline?
        flags += 'y' if obj.sticky?
        return new RegExp(obj.source, flags) 

    newInstance = new obj.constructor()

    for key of obj
        newInstance[key] = clone obj[key]

    return newInstance

@pad = (s, c, t, { end = no } = {}) ->
    length = s.length
    padding = (c for i in [length...t]).join("")

    if end
        s + padding
    else
        padding + s

@alignTo = (address, bytes) -> (((address/bytes) | 0) + ((address&(bytes-1)) isnt 0))*bytes


markLineFrom = (line, start, end) ->
    unless start?
        start = line.search(/\S/) - 1

    unless end?
        end = line.length - 1

    Array(start + 2).join(" ") + Array(end - start + 1).join("~")

@locationsMessage = (code, locations) ->
    locations = clone locations

    { lines, columns } = locations

    lineColumnSpec = "code.cc:#{lines.first}:#{columns.first}: "

    # We want zero-based numbers
    --lines.first
    --lines.last
    --columns.first
    --columns.last

    codeLines = code.split('\n')

    relevantCodeLines = codeLines[lines.first..lines.last]

    markLines = []

    if relevantCodeLines.length is 1
        markLines.push markLineFrom(relevantCodeLines[0], columns.first, columns.last)
    else
        markLines.push markLineFrom(relevantCodeLines[0], columns.first)
        markLines.push markLineFrom(relevantCodeLines[lineNumber], null, null) for lineNumber in [1...relevantCodeLines.length - 1]
        markLines.push markLineFrom(relevantCodeLines[relevantCodeLines.length - 1], null, columns.last)


    {
        lineColumnSpec,
        relevantCode: [0...relevantCodeLines.length*2].map((x, i) -> if i&1 then markLines[i >> 1] else relevantCodeLines[i >> 1]).join("\n")
    }

@indent = (text, spaces) -> text.split('\n').map((x) -> Array(spaces + 1).join(" ") + x).join("\n")