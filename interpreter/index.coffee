assert = require 'assert'

Error = require '../error'
Ast = require '../parser/ast'
Stack = require './stack'

funcName2Tree = {}
stack = new Stack

module.exports =
  load: (root) ->
    assert.notStrictEqual root, undefined
    mapFunctions root
    return
  run: ->
    executeFunction 'main', null
    return

mapFunctions = (T) ->
  assert.strictEqual T.getType(), 'BLOCK-FUNCTIONS'
  funcName2Tree = {}
  n = T.getChildCount()
  i = 0
  while i < n
    subTree = T.getChild(i)
    assert.strictEqual subTree.getType(), 'FUNCTION'
    funcName = subTree.getChild(1).getChild(0)
    funcName2Tree[funcName] = subTree
    ++i
  return

executeFunction = (funcName, args) ->
  func = funcName2Tree[funcName]
  assert.notStrictEqual func, undefined, 'Function ' + funcName + ' not declared'
  arg_values = listArguments(func.getChild(2), args)
  stack.pushActivationRecord funcName
  narg = arg_values.length
  i = 0
  while i < narg
    stack.defineVariable arg_values[i].id, arg_values[i].value
    ++i
  result = executeListInstructions func.getChild(3)
  stack.popActivationRecord()
  # If main function is executed and no result is returned, value 0 is returned
  if funcName == 'main' and !result
    return 0
  result

listArguments = (fParams, args) ->
  if args == null
    return []
  if args.getChildCount() == 0
    return []
  if fParams.getChildCount() != args.getChildCount()
    throw 'Incorrect number of parameters'
  n = fParams.getChildCount()
  params = []
  i = 0
  while i < n
    param = fParams.getChild(i)
    arg = args.getChild(i)
    params.push
      id: param.getChild(1).getChild(0)
      value: evaluateExpression(arg.getChild(0))
    ++i
  params

executeListInstructions = (T) ->
  assert.notStrictEqual T, undefined
  result = undefined
  ninstr = T.getChildCount()
  i = 0
  while i < ninstr
    result = executeInstruction(T.getChild(i))
    if result != undefined
      return result
    ++i
  null