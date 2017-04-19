assert = require 'assert'

module.exports = @

@compile = (root) ->
    assert root?, "Check semantics received a null ast"

    root.compile()