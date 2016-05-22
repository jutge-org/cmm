var assert = require('assert');
var util = require('util');

var Stack = require('./stack');
var Data = require('./data');
var OP = require('./utils').Op;
var EL = require('./utils').Element;

var funcName2Tree;
var stack = new Stack();

module.exports = {
    load: function(root) {
        assert.notStrictEqual(root, undefined);
        mapFunctions(root);
        assert.notStrictEqual(funcName2Tree["main"], undefined, "Main function must exist");
        preProcessAST(root);
        
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
        assert.strictEqual(funcName2Tree[funcName], undefined, "Multiple definitions of function " + funcName);
        funcName2Tree[funcName] = subTree;
    }
}

function preProcessAST(T) {
    if (T === null || T === undefined) return;
    if (T.type === undefined) return;
    switch (T.getType()) {
        case EL.INTEGER: T.children[0] = parseInt(T.getChild(0)); break;
        case EL.REAL:    T.children[0] = parseFloat(T.getChild(0)); break;
        case 'TYPE-DECL':
            for(var i = 0; i < T.getChild(1).length; ++i) {
                preProcessAST(T.getChild(1)[i]);
            }
    }
    var n = T.getChildCount();
    for (var i = 0; i < n; ++i) preProcessAST(T.getChild(i));
}

function executeFunction(funcName, args) {
    var func = funcName2Tree[funcName];
    assert.notStrictEqual(func, undefined, "Function "+funcName+" not declared");
    // TODO work with list arguments
    stack.pushActivationRecord(funcName);
    var result = executeListInstructions(func.getChild(2));
    if (result) result = new Data();
    stack.popActivationRecord();
    return result;
}

function executeListInstructions(T) {
    assert.notStrictEqual(T, undefined);
    var result; //Data obj
    var ninstr = T.getChildCount();
    for (var i = 0; i < ninstr; ++i) {
        result = executeInstruction(T.getChild(i));
        if (result !== undefined) return result;
    }
    return null;
}

function executeInstruction(T) {
    assert.notStrictEqual(T, undefined);
    var value;
    switch (T.getType()) {
        case 'TYPE-DECL':
            var type = T.getChild(0);
            var decl = T.getChild(1);
            var declNum = decl.length;
            for (var i = 0; i < declNum; ++i) {
                var atom = decl[i];
                var varName = atom.getChild(0);
                if (atom.getType() === 'ASSIGN') {
                    value = evaluateExpression(atom.getChild(1));
                    stack.defineVariable(varName, new Data(type, value));
                }
                else if (atom.getType() === 'ID') stack.defineVariable(varName, new Data(type, undefined));
            }
            break;
    }
}

function evaluateExpression(T) {
    //TODO implement method
    return -1;
}