{ parser } = require './parser/grammar.jison'
{ checkSemantics } = require './semantics/'
interpreter = require './interpreter/'
Ast = require './parser/ast.coffee'
io = require './interpreter/io'

parser.yy = { Ast }

@compile = (code) ->
    ast = parser.parse code
    ast = checkSemantics ast

    ast

@execute = (ast, input) ->
    interpreter.load ast

    iterator = interpreter.run(input)

    loop
      { value, done } = iterator.next()
      yield value
      break unless not done
      result = value
    yield result

@hooks = {
    setInput: (input) -> io.setInput(io.STDIN, input)
    isInputBufferEmpty: -> io.isInputBufferEmpty(io.STDIN)
}

@events = {
    onstdout: (cb) -> interpreter.onstdout cb
}


self.cmm = @
