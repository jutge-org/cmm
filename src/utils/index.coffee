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