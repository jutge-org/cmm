assert = require 'assert'

module.exports = @

@checkSemantics = (root) ->
    assert root?, "Check semantics received a null ast"

    root.compile()

    root.child() # TODO: Should be root!

