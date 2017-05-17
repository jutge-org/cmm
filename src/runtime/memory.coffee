DataView = require 'fast-dataview'

module.exports = @

{ BASIC_TYPES: { LARGEST_ASSIGNABLE: { bytes: largestAssignableBytes } } } = require '../ast/type'

GB = 1024

@Memory = class Memory
    @SIZES: {
        heap: 2*GB
        stack: 2*GB
        tmp: 2*GB
        return: largestAssignableBytes
    }

    constructor: (@pointers) ->
        for memoryCompartment, size of Memory.SIZES
            @[memoryCompartment + 'Buffer'] = buffer = new ArrayBuffer size
            @[memoryCompartment] = new DataView buffer

        @[0] = @stack
        @[1] = @heap


