assert = require 'assert'

module.exports = @

compilationErrors = require './compilation-error'
executionErrors = require './execution-error'
compilationWarnings = require './compilation-warning'

@compilationError = (name, locations, others...) ->
    assert compilationErrors[name]?, "Invalid compilation error #{name}"

    error = compilationErrors[name]

    error.locations = locations

    if others.length
        error = error.complete(others...)

    throw error

@executionError = (vm, name, others...) ->
    assert executionErrors[name]?, "Invalid execution error #{name}"

    error = executionErrors[name]

    if others.length
        error = error.complete(others...)

    vm.executionError(error)

@compilationWarning = (state, name, others...) ->
    assert compilationWarnings[name]?, "Invalid compilation warning #{name}"

    warning = compilationWarnings[name]

    if others.length
        warning = warning.complete(others...)

    state.warn(warning)
