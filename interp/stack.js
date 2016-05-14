function Stack() {
    this.stack = [];
    this.currentAR = undefined;
}

Stack.prototype.pushActivationRecord = function(name) {
    this.currentAR = {};
    this.stack.push(this.currentAR);
};

Stack.prototype.popActivationRecord = function() {
    this.stack.pop();
    if (this.stack.length === 0) this.currentAR = undefined;
    else this.currentAR = this.stack[this.stack.length-1];
};

Stack.prototype.defineVariable = function(name, value) {
    var type = this.currentAR[name].getType();
    if (value.getType() === type) {
        this.currentAR[name] = value;
    } else {
        throw "Variable " + name + " is already defined as " + type;
    }
};

Stack.prototype.getVariable = function (name) {
    var v = this.currentAR[name];
    if (v === undefined) {
        throw "Variable " + name + " not defined";
    }
    return v;
};

module.exports = Stack;