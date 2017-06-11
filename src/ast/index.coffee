module.exports = @

modules = []

# Not done dynamically with fs.readdir because it causes problems with browserify
modules.push require('././address-of')
modules.push require('./array-subscript')
modules.push require('./assign-op')
modules.push require('./assign')
modules.push require('./ast')
modules.push require('./binary-op')
modules.push require('./branch')
modules.push require('./cin')
modules.push require('./conditional')
modules.push require('./cout')
modules.push require('./declaration')
modules.push require('./dereference')
modules.push require('./for')
modules.push require('./funcall')
modules.push require('./function')
modules.push require('./id')
modules.push require('./index')
modules.push require('./initializer')
modules.push require('./list')
modules.push require('./literals')
modules.push require('./memory-reference')
modules.push require('./new-delete')
modules.push require('./program-ast')
modules.push require('./read')
modules.push require('./return')
modules.push require('./type')
modules.push require('./unary-op')
modules.push require('./while')
modules.push require('./write')

for myModule in modules
    for key, value of myModule
        @[key] = value
