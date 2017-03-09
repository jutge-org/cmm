cmm = require '.'

asciitree = require 'ascii-tree'

printAsciiTree = (json) ->
    _traverse = (list, node, level) ->
        level++
        prefix = Array(level + 1).join("#")
        type = typeof node
        if node == undefined or node == null
# Array.isArray([])?
            list.push prefix + node
        else if Array.isArray(node)
            for elem in node
                _traverse(list, elem, level-1)
        else if type == 'object'
            Object.keys(node).forEach (k) ->
                list.push prefix + k
                _traverse list, node[k], level
                return
        else
# string boolean
            list.push prefix + node
        return

    list = []
    _traverse list, json, 0
    tree = asciitree.generate(list.join('\u000d\n'))
    console.log tree

[code, input] = process.argv[2..]

input = "" unless input?


code = """
int f() {
    return 5;
}

int main() {
    int x = f();
}
"""

input = """

"""


ast = cmm.compile(code)

printAsciiTree(ast.toObject())

iterator = cmm.execute(ast, input)

output = ""
cmm.events.onstdout((partial_output) -> output += partial_output)

loop
    { done } = iterator.next()
    break if done


console.log output
