assert = require 'assert'
asciitree = require 'ascii-tree'
utils = require '../utils'
{ compilationError } = require '../messages'
module.exports = @

@Ast = class Ast
    constructor: (@children...) ->
        assert(typeof child isnt "undefined") for child in @children

        @children = (child for child in @children when child isnt null)
        assert @constructor.name isnt "Ast", "Ast should only be instantiated via subclass"

    getSymbol: -> @name # Returns a representation of the Ast node type (While/+=/- etc.)

    addParent: (ast) ->
        thisCopy = new @constructor()
        for key, value of this
            thisCopy[key] = value

        ast.addChild thisCopy

        for key, value of ast
            this[key] = value


    # These are to simplify and beautify some code
    child: -> @children[0]
    left: -> @children[0]
    right: -> @children[1]

    getChild: (i) -> @children[i]

    getChildren: -> @children

    addChild: (child) -> @children.push child if child isnt null

    setChild: (i, value) -> @children[i] = value

    getChildCount: -> @children.length

    @copyOf: (other) -> utils.cloneDeep(other)

    compilationError: (name, others...) ->
        compilationError(name, @locations, others...)

    toObject:  ->
        parent = {}

        parent[@getSymbol()] = []
        i = 0
        for child in @children
            if child instanceof Ast
                parent[@getSymbol()][i] = child.toObject()
                ++i
            else if Array.isArray(child)
                for subChild in child
                    if subChild instanceof Ast
                        parent[@getSymbol()][i] = subChild.toObject()
                    else
                        parent[@getSymbol()][i] = subChild
                    ++i
            else
                parent[@getSymbol()][i] = child
                ++i
        parent

    toString: ->
        _traverse = (list, node, level) ->
            ++level
            prefix = Array(level + 1).join("#")

            unless node?
                list.push prefix + node
            else if Array.isArray(node)
                for elem in node
                    _traverse(list, elem, level-1)
            else if typeof node is 'object'
                Object.keys(node).forEach (k) ->
                    list.push prefix + k
                    _traverse list, node[k], level
            else
                list.push prefix + JSON.stringify(node)

        list = []
        _traverse list, @toObject(), 0
        asciitree.generate(list.join('\u000d\n'))
