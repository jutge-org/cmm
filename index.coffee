{ parser } = require './parser/grammar.jison'
{ checkSemantics } = require './semantics/'
interpreter = require './interpreter/'
Ast = require './parser/ast.coffee'
io = require './interpreter/io'
Stack = require './interpreter/stack'
{ stepInto, stepOver, stepOut } = require './debugger/steps'

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
      break unless not done
      yield value: value, stack: Stack.stack
    yield 0

@hooks = {
    setInput: (input) -> io.setInput(io.STDIN, input)
    isInputBufferEmpty: -> io.isInputBufferEmpty(io.STDIN)
    modifyVariable: (stackNumber, varName, value) -> Stack.stack[stackNumber].variables[varName].value = value
}

@events = {
    onstdout: (cb) -> interpreter.onstdout cb
}

@actions = {
    stepOut: -> stepOut()
    stepOver: -> stepOver()
    stepInto: -> stepInto()
}


self.cmm = @
