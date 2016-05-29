var TYPE = require('./utils').TYPE;
var OPERATOR = require('./utils').OPERATOR;
var assert = require('assert');

var ensureType = require('./utils').ensureType;

function Data(a, b) {
    ensureType(this);

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

Data.prototype.isChar = function() {
    return this.type === TYPE.CHAR;
}

Data.prototype.getValue = function() {
    return this.value;
};

Data.prototype.setValue = function (value) {
    this.value = value;
    ensureType(this);
};

Data.prototype.setData = function (data) {
    this.type = data.type;
    this.value = data.value;
    ensureType(this);
};

Data.prototype.checkDivZero = function (data) {
    if (data.value === 0) {
        throw "Division by zero";
    }
};

Data.prototype.evaluateRelational = function (op, data) {
    throw "Unimplemented method";
};

module.exports = Data;
