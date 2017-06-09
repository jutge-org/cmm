assert = require 'assert'


{ Message } = require './message'

# Read out of range (arrays)

# Variable redeclaration (shadowing)


w = (name, code, message, description) =>
    assert not module.exports[name]?, "Warning #{name} already in use"

    for messageName, messageObject of module.exports
        assert messageObject.code isnt code, "Warning code #{code} for #{name} already in use by #{messageName}"

    new Message code, message + "\n", "Warning", description

module.exports = {}

for errorType, map of @
    for name, { code, message, description } of map
        module.exports[name] = w(name, code, message, description)