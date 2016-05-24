var Type = require('./utils').Type;
var OP = require('./utils').Op;
var assert = require('assert');

function Data(a, b) {
    if (arguments.length === 0) {
        this.type = Type.VOID;
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
    return this.type === Type.INT;
};

Data.prototype.isDouble = function () {
    return this.type === Type.DOUBLE;
};

Data.prototype.isVoid = function () {
    return this.type === Type.VOID;
};

Data.prototype.isString = function () {
    return this.type === Type.STRING;
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
    if (this.type === Type.STRING && data.type === Type.STRING) {
        switch (op) {
            case OP.PLUS: this.value += data.value; return;
            default: throw "Unsupported operation";
        }
    }
    if (this.type === Type.VOID || this.type === Type.VOID) {
        throw "VOID type does not have any operation";
    }

    switch (op) {
        case OP.PLUS: this.value += data.value; break;
        case OP.MINUS: this.value -= data.value; break;
        case OP.MUL: this.value *= data.value; break;
        case OP.DIV: this.value /= data.value; console.log(this.value); break;
        case OP.MOD: this.value %= data.value; break;
        default: throw "Unsupported operation";
    }
};

Data.prototype.evaluateRelational = function (op, data) {
    throw "Unimplemented method";
};

function checkType(data) {
    var type = data.type;
    var value = data.value;
    switch(type) {
        case 'int':
            // Check if it's a real or int, 
            if (value == parseInt(data.value) || value == parseFloat(data.value)) {
                data.value = parseInt(data.value);
            } else throw "Wrong type";
            break;
        case 'double':
            if (value !== parseInt(data.value) && value !== parseFloat(data.value))
                throw "Wrong type";
            break;
    }
}

module.exports = Data;