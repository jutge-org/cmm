{ PRIMITIVE_TYPES: { LARGEST_ASSIGNABLE: { bytes: largestAssignableBytes } } } = require '../ast/type'
{ executionError } = require '../messages'


class DataView # Fast implementation of Javascript DataView
    genr: (array, shift, address) ->
        v = array[address >> shift]
        if v is undefined
            executionError @vm, 'SEGFAULT'
        v

    genw: (array, shift, address, value) ->
        if address < 0 or address >= array.length
            executionError @vm, 'SEGFAULT'
        else
            array[address >> shift] = value

    constructor: (@buffer) ->
        @int8Array = new Int8Array(@buffer, 0);
        @uint8Array = new Uint8Array(@buffer, 0);
        @int16Array = new Int16Array(@buffer, 0);
        @uint16Array = new Uint16Array(@buffer, 0);
        @int32Array = new Int32Array(@buffer, 0);
        @uint32Array = new Uint32Array(@buffer, 0);
        @float32Array = new Float32Array(@buffer, 0);
        @float64Array = new Float64Array(@buffer, 0);

    getInt8: (address) -> @genr(@int8Array, 0, address)
    getUint8: (address) -> @genr(@uint8Array, 0, address)
    getInt16: (address) -> @genr(@int16Array, 1, address)
    getUint16: (address) -> @genr(@uint16Array, 1, address)
    getInt32: (address) -> @genr(@int32Array, 2, address)
    getUint32: (address) -> @genr(@uint32Array, 2, address)
    getFloat32: (address) -> @genr(@float32Array, 2, address)
    getFloat64: (address) -> @genr(@float64Array, 3, address)

    setInt8: (address, value) -> @genw(@int8Array, 0, address, value)
    setUint8: (address, value) -> @genw(@uint8Array, 0, address, value)
    setInt16: (address, value) -> @genw(@int16Array, 1, address, value)
    setUint16: (address, value) -> @genw(@uint16Array, 1, address, value)
    setInt32: (address, value) -> @genw(@int32Array, 2, address, value)
    setUint32: (address, value) -> @genw(@uint32Array, 2, address, value)
    setFloat32: (address, value) -> @genw(@float32Array, 2, address, value)
    setFloat64: (address, value) -> @genw(@float64Array, 3, address, value)

module.exports = @

MB = 1024*1024

@Memory = class Memory
    @SIZES: {
        heap: 256*MB
        stack: 128*MB
        tmp: 64*MB
        return: largestAssignableBytes
    }

    constructor: ->
        for memoryCompartment, size of Memory.SIZES
            @[memoryCompartment + 'Buffer'] = buffer = new ArrayBuffer size
            @[memoryCompartment] = new DataView buffer

        @[0] = @stack
        @[1] = @heap

    setVM: (@vm) ->
        for memoryCompartment, size of Memory.SIZES
            @[memoryCompartment].vm = @vm
            
    setPointers: (@pointers) ->

    resetHeapBuffer: ->
        @heapBuffer = new ArrayBuffer Memory.SIZES.heap
        @heap = new DataView @heapBuffer
        @heap.vm = @vm