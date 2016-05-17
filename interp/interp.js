var assert = require('assert');

var funcName2Tree;

module.exports = {
    load: function(root) {
        assert.notStrictEqual(root, undefined);
        mapFunctions(root);
        // TODO *maybe* preprocess literals
    },
    run: function() {
        executeFunction("main", null)
    }
};

function mapFunctions(T) {
    assert.strictEqual(T.getType(), "BLOCK-FUNCTIONS");
    funcName2Tree = {};
    var n = T.getChildCount();
    for (var i = 0; i < n; ++i) {
        var subTree = T.getChild(i);
        assert.strictEqual(subTree.getType(), "FUNCTION");
        var funcName = subTree.getChild(1).getChild(0);
        if (funcName2Tree[funcName] !== undefined) {
            throw "Multiple definitions of function " + funcName;
        }
        funcName2Tree[funcName] = subTree;
    }
}

function executeFunction(funcName, args) {
    // TODO
}

