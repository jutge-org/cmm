var Type = require('./utils').Type;

function Data(d, type, value) {
    if (arguments.length === 0) {
        this.type = Type.VOID;
    } else if (arguments.length === 1 && typeof d === "object") {
        this.type = d.type;
        this.value = d.value;
    } else if (arguments.length === 2) {
        this.type = type;
        this.value = value;
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

module.exports = Data;