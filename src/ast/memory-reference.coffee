assert = require 'assert'

{ Ast } = require './ast'

module.exports = @

MALLOC_HEADER_SIZE = 272 # Needed for the malloc library
HEAP_INITIAL_ADDRESS = MALLOC_HEADER_SIZE 

@MemoryReference = class MemoryReference extends Ast
    constructor: (type, address) ->
        assert type.isAssignable

        super type, address

    getValue: -> #TODO: Access memory and return

    getType: -> @children[0]
    getAddress: -> @children[1]

    # [ type, address ] =  @children

@ReturnReference = class ReturnReference extends Ast
    constructor: (type) -> super type

@StackReference = class StackReference extends MemoryReference
@HeapReference = class HeapReference extends MemoryReference
    constructor: (type, address) ->
        super type, address + HEAP_INITIAL_ADDRESS

@TmpReference = class TmpReference extends MemoryReference
    isTemporary: true