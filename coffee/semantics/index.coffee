variableChecker = require './variable-checker'
typePreprocessor = require './type-preprocessor'

module.exports = @

@checkSemantics = (ast) ->
    variableChecker.checkVariables ast
