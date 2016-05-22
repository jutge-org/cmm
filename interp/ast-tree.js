var scope = exports;

scope.AstNode = function (type, params) {
    this.type = type;
    this.children = params;
    return this;
};

scope.AstNode.prototype.getType = function () {
    return this.type;
};

scope.AstNode.prototype.getChild = function(i) {
    return this.children[i];
};

scope.AstNode.prototype.addChild = function(child) {
    return this.children.push(child);
};

scope.AstNode.prototype.getChildCount = function () {
    return this.children.length;
};