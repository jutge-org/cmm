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
    var data = this.currentAR[name];
    if (data === undefined) {
        this.currentAR[name] = value;
    } else {
        throw "Variable " + name + " is already defined.";
    }
};

Stack.prototype.getVariable = function (name) {
    var v = this.currentAR[name];
    if (v === undefined) {
        throw "Variable " + name + " not defined";
    }
    return v;
};

Stack.prototype.setVariable = function (name, data) {
    console.log(data);
    console.log(this.currentAR[name]);
    var v = this.currentAR[name];
    if (v === undefined) {
        var msg = "Variable " + name + " not defined";
        throw new Error(msg);
    }
    if (data === undefined) {
        var msg = "Assignment value not defined";
        throw new Error(msg);
    }
    if (v.type !== data.type) {
        var msg = "Assignment value type doesn't match variable type";
        throw new Error(msg);
    }
    this.currentAR[name] = data;
    console.log(name + ' = ' + data.value);
};

module.exports = Stack;