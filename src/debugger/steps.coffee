{ instructionQueue } = require '../interpreter/vm-state'
Ast = require '../parser/ast'
{ getFunctionMap } = require '../interpreter/function'

{ NODES, STATEMENTS, OPERATORS } = Ast

@stepOut = ->
  i = instructionQueue.length - 1
  while i >= 0
    break if instructionQueue[i].getType() is NODES.END_FUNC_BLOCK
    --i
  instructionQueue[--i].stop = yes

@stepOver = ->
  i = instructionQueue.length - 1
  while i >= 0
    if instructionQueue[i].getType() is NODES.FUNCALL
      instructionQueue[i].stop = yes
      break
    if instructionQueue[i].getType() is NODES.END_FUNC_BLOCK and i > 0
      instructionQueue[--i].stop = yes
      break
    --i

@stepInto = ->
  instr = instructionQueue[instructionQueue.length - 1]
  if instr.getType() is NODES.FUNCALL
    { instructions } = getFunctionMap()[instr.getChild(0).getChild(0)]
    console.log instructions
    instructions.getChild(0).stop = yes
  else
    instr.stop = yes

module.exports = @
