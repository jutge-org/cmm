var TYPE = require('./utils').TYPE;
var OPERATOR = require('./utils').OPERATOR;
var assert = require('assert');

var checkType = require('./utils').checkType;

function Data(a, b) {
    if (arguments.length === 0) {
        this.type = TYPE.VOID;
        this.value = undefined;
    } else if (arguments.length === 1 && typeof a === "object") {
        this.type = a.type;
        this.value = a.value;
    } else if (arguments.length === 2) {
        this.type = a;
        this.value = b;
    } else {
        throw "Wrong parameters";
    }
}

Data.prototype.getType = function () {
    return this.type;
};

Data.prototype.isInteger = function () {
    return this.type === TYPE.INT;
};

Data.prototype.isDouble = function () {
    return this.type === TYPE.DOUBLE;
};

Data.prototype.isVoid = function () {
    return this.type === TYPE.VOID;
};

Data.prototype.isString = function () {
    return this.type === TYPE.STRING;
};

Data.prototype.getValue = function() {
    return this.value;
};

Data.prototype.setValue = function (value) {
    this.value = value;
    checkType(this);
};

Data.prototype.setData = function (data) {
    this.type = data.type;
    this.value = data.value;
    checkType(this);
};

Data.prototype.checkDivZero = function (data) {
    if (data.value === 0) {
        throw "Division by zero";
    }
};

// TODO do more and better type checking
Data.prototype.evaluateArithmetic = function (op, data) {
    if (this.type === TYPE.STRING && data.type === TYPE.STRING) {
        switch (op) {
            case OPERATOR.PLUS: this.value += data.value; return;
            default: throw "Unsupported operation";
        }
    }
    if (this.type === TYPE.VOID || this.type === TYPE.VOID) {
        throw "VOID type does not have any operation";
    }

    switch (op) {
        case OPERATOR.PLUS: this.value += data.value; break;
        case OPERATOR.MINUS: this.value -= data.value; break;
        case OPERATOR.MUL: this.value *= data.value; break;
        case OPERATOR.DIV: this.value /= data.value; console.log(this.value); break;
        case OPERATOR.MOD: this.value %= data.value; break;
        default: throw "Unsupported operation";
    }
};

Data.prototype.evaluateRelational = function (op, data) {
    throw "Unimplemented method";
};

module.exports = Data;