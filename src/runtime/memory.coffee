{ PRIMITIVE_TYPES: { LARGEST_ASSIGNABLE: { bytes: largestAssignableBytes } } } = require '../ast/type'

class DataView # Fast implementation of Javascript DataView
    constructor: (@buffer) ->
        @int8Array = new Int8Array(@buffer, 0);
        @uint8Array = new Uint8Array(@buffer, 0);
        @int16Array = new Int16Array(@buffer, 0);
        @uint16Array = new Uint16Array(@buffer, 0);
        @int32Array = new Int32Array(@buffer, 0);
        @uint32Array = new Uint32Array(@buffer, 0);
        @float32Array = new Float32Array(@buffer, 0);
        @float64Array = new Float64Array(@buffer, 0);

    getInt8: (address) -> @int8Array[address]
    getUint8: (address) -> @uint8Array[address]
    getInt16: (address) -> @int16Array[address >> 1]
    getUint16: (address) -> @uint16Array[address >> 1]
    getInt32: (address) -> @int32Array[address >> 2]
    getUint32: (address) -> @uint32Array[address >> 2]
    getFloat32: (address) -> @float32Array[address >> 2]
    getFloat64: (address) -> @float64Array[address >> 3]

    setInt8: (address, value) -> @int8Array[address] =  value
    setUint8: (address, value) -> @uint8Array[address] =  value
    setInt16: (address, value) -> @int16Array[address >> 1] =  value
    setUint16: (address, value) -> @uint16Array[address >> 1] =  value
    setInt32: (address, value) -> @int32Array[address >> 2] =  value
    setUint32: (address, value) -> @uint32Array[address >> 2] =  value
    setFloat32: (address, value) -> @float32Array[address >> 2] =  value
    setFloat64: (address, value) -> @float64Array[address >> 3] =  value

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

    setPointers: (@pointers) ->